class GateCount::CardSwipe < GateCount::Base
  def self.superadmin_columns = [
    :first_name, :last_name, :card_num, :pennkey
  ]

  def self.on_conflict_update
    {
      conflict_target: [:swipe_date, :door_name, :card_num],
      columns: []
    }
  end

  # Fill in the remaining demographic information
  def self.update_demographics
    # SQL query to update demographic information based on potential pennkey
    query = <<-SQL
UPDATE gate_count_card_swipes
  SET (
    statistical_category_1,
    statistical_category_2,
    statistical_category_3,
    statistical_category_4,
    statistical_category_5,
    user_group,
    school,
    pennkey
  ) = (
    upenn_alma_demographics.statistical_category_1,
    upenn_alma_demographics.statistical_category_2,
    upenn_alma_demographics.statistical_category_3,
    upenn_alma_demographics.statistical_category_4,
    upenn_alma_demographics.statistical_category_5,
    upenn_alma_demographics.user_group,
    upenn_alma_demographics.school,
    upenn_alma_demographics.pennkey
  )
FROM upenn_alma_demographics
WHERE
  gate_count_card_swipes.pennkey IS NULL
  AND gate_count_card_swipes.card_num IS NOT NULL
  AND upenn_alma_demographics.penn_id = gate_count_card_swipes.card_num;
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end

  def self.update_kislak_swipes
    query = <<-SQL
      INSERT INTO gate_count_kislak_swipes (
        fiscal_year,
        year,
        month,
        door_name,
        name,
        total_swipes
      )
      SELECT 
        EXTRACT(year FROM swipe_date + INTERVAL '6 months'), 
        EXTRACT(year FROM swipe_date), 
        EXTRACT(month FROM swipe_date), 
        door_name, 
        CONCAT(first_name, ' ', last_name), 
        COUNT(*)
      FROM gate_count_card_swipes 
      WHERE door_name ILIKE '%kislak%' 
      GROUP BY 1, 2, 3, 4, 5
      ORDER BY 1, 2, 3, 4, 5 DESC
      ON CONFLICT (year, month, door_name, name)
      DO UPDATE
      SET total_swipes = EXCLUDED.total_swipes; 
    SQL

    # Execute the raw SQL
    ActiveRecord::Base.connection.execute(query)
  end

  # Function to auto update tables after upload via file import tool
  def self.update_after_import
    self.update_demographics
    self.update_kislak_swipes
  end
end
