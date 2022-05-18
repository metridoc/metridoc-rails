class AddSchoolToUpennAlmaDemographics < ActiveRecord::Migration[5.2]
  def change
    add_column :upenn_alma_demographics, :school, :string
  end
end
