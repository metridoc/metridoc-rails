class AddCrLegantoCourseRefToCrLegantoUsages < ActiveRecord::Migration[7.1]
  def change
    add_reference :cr_leganto_usage, :cr_leganto_course, null: false, foreign_key: true
    add_reference :cr_leganto_usage, :cr_leganto_citation, null: false, foreign_key: true
  end
end
