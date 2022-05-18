class CreateUpennAlmaDepartments < ActiveRecord::Migration[5.2]
  def change
    create_table :upenn_alma_departments do |t|
      t.string :department_code
      t.string :school
    end
  end
end
