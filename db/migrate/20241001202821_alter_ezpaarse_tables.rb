class AlterEzpaarseTables < ActiveRecord::Migration[7.1]
  def change
    # Add column for unique index
    add_column :ezpaarse_logs, :checksum_index, :string

    # Define reversable migrations
    reversible do |direction|
      # Change the publication date to a text field
      change_table :ezpaarse_logs do |t|
        direction.up { t.change :publication_date, :string}
        direction.down { t.change :publication_date, :date}
      end

      # Change the date field to a date instead of datetime
      change_table :ezpaarse_hourly_usages do |t|
        direction.up { t.change :date, :date}
        direction.down { t.change :date, :datetime}
      end
    end
    
  end
end
