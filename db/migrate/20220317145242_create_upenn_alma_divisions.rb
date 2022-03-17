class CreateUpennAlmaDivisions < ActiveRecord::Migration[5.2]
  def change
    create_table :upenn_alma_divisions do |t|
      t.string :division
      t.string :division_description
      t.string :school
    end
  end
end
