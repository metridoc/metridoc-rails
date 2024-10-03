class AlterEzpaarseIndex < ActiveRecord::Migration[7.1]
  def change
     add_index :ezpaarse_logs, 
      [:datetime, :checksum_index], 
      unique: true, 
      name: "ezpaarse_logs_index"
  end
end
