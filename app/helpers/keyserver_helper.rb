module KeyserverHelper

  def keyserver_demographic_counts(scope)
    results = Keyserver::DemographicMatrix.new(scope).call

    results.transform_values do |result|
      apply_colors(result[:matrix], result[:max_cnt])
    end
  end

  def keyserver_ranked_table(title:, data:, row_header:)
    render partial: "keyserver/shared/ranked_table",
      locals: {
        title:      title,
        blank_message: "No data are available for this selection.",
        row_header: row_header,
        data:       data
      }
  end

  def keyserver_heatmap_table(title:, data:, hours:, days:)
    render partial: "keyserver/shared/heatmap_table",
      locals: {
        title:      title,
        blank_message: "No data are available for this selection.",
        data:       data,
        hours: hours,
        days: days
      }
  end

  def keyserver_visible_rows(*flags)
    2 + flags.count  # 2 fixed rows (start/end date) + any optional rows
  end

  private

  def interpolate_hex(color1, color2, weight)
    # Extract RGB components from hex strings
    c1 = color1.match(/#?(..)(..)(..)/).captures.map { |x| x.hex }
    c2 = color2.match(/#?(..)(..)(..)/).captures.map { |x| x.hex }

    # Linearly interpolate between the two RGB sets
    r = (c1[0] + (c2[0] - c1[0]) * weight).round
    g = (c1[1] + (c2[1] - c1[1]) * weight).round
    b = (c1[2] + (c2[2] - c1[2]) * weight).round

    # Format back into a valid CSS hex color
    sprintf("#%02x%02x%02x", r, g, b)
  end

  def calculate_color(count, min_cnt, max_cnt)
    if count == 0
      return {bg_color: "#FFFFFF", fg_color: "#6C757D"}
    end

    if count > max_cnt
      return {bg_color: "#6C757D", fg_color: "#FFFFFF"}
    end

    weight = (count - min_cnt).to_f / (max_cnt - min_cnt)
    bg_color = interpolate_hex("#f2E461", "#2B5C8F", weight)
    fg_color = weight < 0.5 ? "#212529" : "#FFFFFF"
    return {bg_color: bg_color, fg_color: fg_color}
  end

  # This helper loops through a matrix and compares the counted value to a maximum count
  # to determine the appropriate background and foreground colors for each cell
  def apply_colors(matrix, max_cnt)
    matrix.each_with_object({}) do |(row, cols), new_matrix|
      new_matrix[row] = cols.each_with_object({}) do |(col, cell), new_cols|
        value = cell[:value]
        new_cols[col] = {
          value: value,
          **calculate_color(value, 0, max_cnt)
        }
      end
    end
  end

  # Set the cell style given the data for the cell
  def cell_style(data)
    "background-color: #{data[:bg_color]}; color: #{data[:fg_color]}; text-align: center;"
  end

  def formatted_cell_count(value)
    if value == 0
      "---"
    elsif value.integer?
      number_with_delimiter(value)
    elsif value < 1
      sprintf('%.2f', value)
    elsif value < 1000
      sprintf('%.3g', value)
    else
      number_with_delimiter(value.round)
    end
  end
  
  def available_computer_count(available, division)
    available.fetch(division, "---")
  end

  def maximum_occupancy_count(occupancy, division)
    occupancy.fetch(division, "---")
  end

  def shaded_cell_tag(data)
    content_tag(:td, style: cell_style(data)) do
      formatted_cell_count(data[:value])
    end
  end

end
