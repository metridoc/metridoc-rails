module GatecountHelper
   
  def gc_years
    max_fiscal_year = (GateCount::CardSwipe.maximum("swipe_date") + 6.months).year
    min_fiscal_year = (GateCount::CardSwipe.minimum("swipe_date") + 6.months).year

    max_fiscal_year.downto(min_fiscal_year).to_a
  end
  
  # Returns a list of schools
  def gc_schools
    gc_schools ||= Upenn::SchoolName.where(:is_school => true).pluck(:code).sort.uniq
  end

  # Returns a list of libraries that use swipes
  def gc_libraries
    gc_libraries ||= Upenn::LibraryDoor.pluck(:library_code).sort.uniq
  end

  def gc_usertype_mapping
    {
      "graduate": {
        "ira": "Graduate Total",
        "alma": "('Grad Student')"
      },
      "undergrad": {
        "ira": "Undergraduate Total",
        "alma": "('Undergraduate Student')"
      },
      "faculty_and_staff": {
        "ira": "Regular Faculty & Staff Total",
        "alma": "('Faculty', 'Faculty Express', 'Staff', 'Library Staff')"
      }
    }
  end

  # Get the breakdown of populations by year
  def gc_library_penetration_query(user_type, fiscal_year)
    user_map = gc_usertype_mapping.fetch(user_type.to_sym, nil)
    return [] if user_map.nil?

    GateCount::CardSwipe.connection.select_all(
    """
      WITH population AS 
        (
          SELECT DISTINCT 
            sn.code AS code, 
            value AS population, 
            fiscal_year 
          FROM upenn_enrollments e 
          INNER JOIN upenn_school_names sn 
            ON sn.ira_affiliations = e.school 
          WHERE 
            fiscal_year = #{fiscal_year} 
            AND 
            sn.is_school = TRUE 
            AND 
            e.user = '#{user_map[:ira]}'
        ),
      swipes AS
        (
          SELECT 
            DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year,
            ld.library_code AS library, 
            sn.code AS school,
            COUNT(card_num) AS swipes, 
            COUNT(DISTINCT card_num) AS persons 
          FROM gate_count_card_swipes cs 
          INNER JOIN upenn_library_doors ld 
            ON ld.door_name = cs.door_name 
          INNER JOIN upenn_school_names sn 
            ON cs.school = sn.alma_affiliations
          WHERE 
            sn.is_school = TRUE 
            AND 
            cs.user_group IN #{user_map[:alma]}
            AND
            cs.swipe_date BETWEEN '#{fiscal_year-1}-07-01' AND '#{fiscal_year}-07-01'
          GROUP BY 1,2,3
        )
      SELECT 
        s.fiscal_year,
        s.library, 
        s.school,
        p.population, 
        s.swipes,
        s.persons
      FROM swipes s
      INNER JOIN population p
        ON p.code = s.school
        AND p.fiscal_year = s.fiscal_year;
      """
    )
  end

  def gc_library_penetration_data(user_type, fiscal_year)
    # Use the query to fetch the penetration data
    data = gc_library_penetration_query(user_type, fiscal_year).to_a

    # Filter to the current fiscal year
    data.filter!{|x| x["fiscal_year"] = fiscal_year}

    # Get a list of the applicable libraries
    libraries = data.pluck("library").uniq

    # Fill the Library Map with data
    libraries_data = {}
    libraries.each do |x|
      library_data =  data.filter{|y| y["library"] == x}
      total_persons = library_data.pluck("persons").sum
      total_swipes = library_data.pluck("swipes").sum
      libraries_data[x] =
        {  
          "persons": library_data.map{|k| [k["school"], k["persons"]]}.to_h,
          "swipes": library_data.map{|k| [k["school"], k["swipes"]]}.to_h,
          "average_active_usage": library_data.map{|k| [k["school"], k["swipes"].fdiv(k["persons"])]}.to_h,
          "average_usage": library_data.map{|k| [k["school"], k["swipes"].fdiv(k["population"])]}.to_h,
          "percent_persons": library_data.map{|k| [k["school"], k["persons"].fdiv(total_persons) * 100]}.to_h,
          "percent_swipes": library_data.map{|k| [k["school"], k["swipes"].fdiv(total_swipes) * 100]}.to_h,
          "percent_penetration": library_data.map{|k| [k["school"], k["persons"].fdiv(k["population"]) * 100]}.to_h
        }
    end

    libraries_data
  end

  def gc_library_entrance_query(timing = "year")
    GateCount::CardSwipe.connection.select_all(
      """
      SELECT 
        'FY' || DATE_PART('year', swipe_date + INTERVAL '6 month') AS fiscal_year,
        CAST(DATE_TRUNC('#{timing}', swipe_date) AS date) AS date,
        ld.library_code AS library, 
        COUNT(card_num) AS swipes, 
        COUNT(DISTINCT card_num) AS persons
      FROM gate_count_card_swipes cs
      INNER JOIN upenn_library_doors ld
        ON ld.door_name = cs.door_name 
      WHERE 
        cs.school != 'Penn Libraries' 
        AND
        swipe_date >= '2015-07-01'
      GROUP BY 1,2,3
      UNION
      SELECT 
        'FY' || fiscal_year AS fiscal_year, 
        CAST(DATE_TRUNC('#{timing}', MAKE_DATE(year, month, 1)) AS date) AS date, 
        'Biotech' AS library, 
        SUM(value) AS swipes, 
        NULL AS persons 
      FROM gate_count_legacy_biotech_counts 
      WHERE MAKE_DATE(year, month, 1) >= '2015-07-01'
      GROUP BY 1, 2, 3 
      ORDER BY 2;
      """
    ).to_a
  end

  def gc_library_entrance_data(timing = "year")
    data = gc_library_entrance_query(timing)

    # Get a list of the applicable libraries
    libraries = data.pluck("library").uniq.sort

    # If daily, only use the most recent fiscal year
    if timing == "day"
      max_fiscal_year = data.pluck("fiscal_year").max
      data.filter!{|y| y["fiscal_year"] == max_fiscal_year}
    end

    # Fill the Library Map with data
    libraries_data = {}

    # Loop through all libraries
    libraries.each do |x|
      # Get the data for a single library
      library_data =  data.filter{|y| y["library"] == x}

      # Select the mapping key based on the timing needed
      time_key = timing == "year" ? "fiscal_year" : "date"

      libraries_data[x] =
        {
          "swipes": library_data.map{|k| [k[time_key], k["swipes"]]}.to_h,
          "persons": library_data.map{
            |k| [k[time_key], k["persons"]]
          }.to_h.reject{
            |k,v| v.nil?
          },
        }
    end

    libraries_data
  end

  # Build the year-to-year comparison table
  def gc_library_entrance_table
    # Pull in the monthly data
    data = gc_library_entrance_data("month")

    libraries_data = {}

    # Loop through each library
    data.each do |k, v|
      # Find the maximum and minimum fiscal years of the data
      min_fiscal_year = (Date::parse(v[:swipes].keys.min) + 6.months).year
      max_fiscal_year = (Date::parse(v[:swipes].keys.max) + 6.months).year

      # Define the fiscal year range
      fiscal_year_range = (min_fiscal_year..max_fiscal_year).to_a

      # Define the months in fiscal year order
      months = Date::ABBR_MONTHNAMES[7..12] + Date::ABBR_MONTHNAMES[1..6]

      # Prepare the swipes data for processing
      counts = v[:swipes].map do |dt, cnt|
        [
          [
            (Date.parse(dt) + 6.months).year, 
            Date.parse(dt).strftime("%b")
          ],
          cnt
        ]
      end.to_h

      # Fill in the count data for the entire range
      count_data = {}
      months.each do |m|
        fiscal_year_range.each do |fy|
          count_data[[fy, m]] = counts.fetch([fy, m], nil)
        end
      end

      # Get the most recent fiscal year counts
      last_fy_counts = counts.filter {
        |dt, cnt| dt.first == max_fiscal_year
      }.map {
        |dt, cnt| [dt.last, cnt]
      }.to_h

      # Find the last fiscal year total
      last_fy_total = last_fy_counts.values.sum

      # Find the percent difference to last fiscal year
      percent_difference = count_data.map do |dt, cnt|
        # Define all nil cases
        # nil for last year
        # nil for no count in fiscal year and month
        # nil for when the last year has no data
        if dt.first == max_fiscal_year
          pct = nil
        elsif cnt.nil?
          pct = nil
        elsif last_fy_counts[dt.last].nil?
          pct = nil
        else
          pct = format_percent(
            (cnt - last_fy_counts[dt.last]).fdiv(last_fy_counts[dt.last])
          )
        end

        [dt, pct]
      end.to_h

      # Assign the appropriate background color for the percent difference.
      count_data_color = count_data.map do |dt, cnt|
        if cnt.nil? || last_fy_counts.fetch(dt.last, 0) == 0
          color = "#FFFFFF"
        elsif cnt > last_fy_counts.fetch(dt.last, 0)
          color = "#ADD8E6"
        else
          color = "#FFA07A"
        end
        [dt, color]
      end.to_h

      # Calculate the Fiscal Year totals
      totals = fiscal_year_range.map do |fy|
        [
          fy,
          count_data
          .filter{|dt,_| dt.first == fy}
          .filter{|_,cnt| cnt.present?}
          .values
          .sum
        ]
      end.to_h

      # Calculate the Percent difference compared to the current FY
      total_percents = totals.map do |fy,cnt|
        [
          fy,
          format_percent(
            (cnt - last_fy_total).fdiv(last_fy_total)
          )
        ]
      end.to_h
      
      # Calculate the colors to highlight the cells by
      total_colors = totals.map do |fy, cnt|
        if cnt.nil?
          color = "#FFFFFF"
        elsif cnt < last_fy_counts.values.sum
          color = "#FFA07A"
        else
          color = "#ADD8E6"
        end
        [fy, color]
      end.to_h

      # Format the totals nicely as strings
      totals = totals.map{ |fy, cnt| [fy, format_big_number(cnt)]}.to_h
      
      # Format the totals nicely as strings
      count_data = count_data.map{ |dt, cnt| [dt, format_big_number(cnt)]}.to_h

      # Build the output hash
      libraries_data[k] = {
        "fiscal_years": fiscal_year_range,
        "months": months,
        "counts": count_data,
        "percent": percent_difference,
        "percent_color": count_data_color,
        "totals": totals,
        "totals_percent": total_percents,
        "total_color": total_colors
      }
    end
  libraries_data
  end

  def gc_frequent_visitor_query(fiscal_year)
    GateCount::CardSwipe.connection.select_all(
      """
      WITH frequency AS (
      SELECT 
        DATE_TRUNC('week', swipe_date) AS week, 
        card_num, 
        library_code AS library, 
        code AS school, 
        COUNT(card_num) AS frequency 
      FROM gate_count_card_swipes cs 
      INNER JOIN upenn_library_doors ld 
        ON ld.door_name = cs.door_name 
      INNER JOIN upenn_school_names sn 
        ON sn.alma_affiliations = cs.school 
      WHERE 
        sn.is_school = TRUE 
        AND 
        DATE_PART('year', swipe_date + INTERVAL '6 month') = #{fiscal_year}
      GROUP BY 1, 2, 3, 4 
      ORDER BY 5 DESC
      ),
      population AS 
        (
          SELECT 
            fiscal_year,
            sn.code AS code,
            SUM(value) AS population
          FROM upenn_enrollments e 
          INNER JOIN upenn_school_names sn 
            ON sn.ira_affiliations = e.school 
          WHERE 
            fiscal_year = #{fiscal_year} 
            AND 
            sn.is_school = TRUE
            AND
            school_parent = 'Total'
            AND
            user_parent = ''
          GROUP BY 1, 2
        )
      SELECT 
        frequency.week,
        frequency.library,
        frequency.school,
        population.population,
        CASE 
          WHEN frequency.frequency < 2 THEN 'Low'
          WHEN frequency.frequency < 5 THEN 'Medium'
          ELSE 'High'
        END AS frequency,
        COUNT(DISTINCT card_num) AS value
      FROM frequency
      INNER JOIN population
      ON population.code = frequency.school
      GROUP BY 1,2,3,4,5;
      """
    ).to_a
  end

  # Calculate the frequency of all visitors
  def gc_frequent_visitors(fiscal_year)
    data = gc_frequent_visitor_query(fiscal_year)

    # Define all available weeks for the plot
    # Start arrays with 0 values
    weeks = data.pluck("week").sort.uniq.map{
      |v| [v.strftime("%b %d"), 0]
    }   

    # Build a structure for the output
    libraries_data = gc_libraries.map do |library|
      [
        library,
        gc_schools.map do |school|
          [
            school,
            {
              'Low': weeks.to_h,
              'Medium':  weeks.to_h,
              'High': weeks.to_h
            }
          ]
        end.to_h
      ]
    end.to_h

    # Loop through the data and update the libraries data output
    data.each do |v|
      library = v.fetch("library")
      school = v.fetch("school")
      freq = v.fetch("frequency").to_sym
      week = v.fetch("week").strftime("%b %d")
      value = v.fetch("value")
      pop = v.fetch("population")

      libraries_data[library][school][freq][week] =
        value.fdiv(pop) * 100.0
    end

    libraries_data
  end

  def gc_hourly_visitor_query(fiscal_year)
    GateCount::CardSwipe.connection.select_all(
      """
      WITH hourly AS (
        SELECT 
          DATE_PART('dow', swipe_date) AS day_of_week,
          DATE_PART('hour', swipe_date) AS hour_of_day,
          ld.library_code AS library, 
          COUNT(card_num) AS swipes, 
          COUNT(DISTINCT card_num) AS persons
        FROM gate_count_card_swipes cs
        INNER JOIN upenn_library_doors ld
          ON ld.door_name = cs.door_name 
        WHERE 
          cs.school != 'Penn Libraries' 
          AND
          DATE_PART('year', swipe_date + INTERVAL '6 month') = #{fiscal_year}
        GROUP BY 1,2,3
      )
      SELECT
        day_of_week,
        hour_of_day,
        library,
        AVG(swipes) AS swipes,
        AVG(persons) AS persons
      FROM hourly
      GROUP BY 1,2,3;
      """
    ).to_a
  end

  def gc_hourly_visitors(fiscal_year)
    data = gc_hourly_visitor_query(fiscal_year)

    hours = 0.upto(23).to_a.map{|k| [k, 0]}

    # Build a structure for the output
    # Maps libraries to days to hours to average counts
    libraries_data = gc_libraries.map do |library|
      [
        library,
        0.upto(6).to_a.map do |day|
          [
            Date::DAYNAMES[day],
            hours.to_h
          ]
        end.to_h
      ]
    end.to_h

    data.each do |v|
      day = Date::DAYNAMES[v["day_of_week"].to_i]
      hour_of_day = v["hour_of_day"].to_i
      libraries_data[v["library"]][day][hour_of_day] = v["swipes"]
    end

    libraries_data
  end
end
