class CreateUpennAlmaTables < ActiveRecord::Migration[5.2]
  def change
    create_table :upenn_alma_demographics do |t|
      t.string :identifier_value, limit: 8
      t.boolean :status
      t.date :status_date
      t.string :statistical_category_1
      t.string :statistical_category_2
      t.string :statistical_category_3
      t.string :statistical_category_4
      t.string :statistical_category_5
    end
    add_index :upenn_alma_demographics, :statistical_category_1
    add_index :upenn_alma_demographics, :statistical_category_2
    add_index :upenn_alma_demographics, :statistical_category_3
    add_index :upenn_alma_demographics, :statistical_category_4
    add_index :upenn_alma_demographics, :statistical_category_5
  end
end
