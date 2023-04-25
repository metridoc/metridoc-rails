class CreateUpennEnrollment < ActiveRecord::Migration[5.2]
  def change
    create_table :upenn_enrollments do |t|
      t.string :user
      t.string :school
      t.integer :value
      t.integer :fiscal_year
    end
  end
end
