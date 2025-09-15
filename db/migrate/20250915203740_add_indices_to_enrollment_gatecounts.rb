class AddIndicesToEnrollmentGatecounts < ActiveRecord::Migration[7.1]
  def change
    add_index :upenn_enrollments, [
      :user, :school, :fiscal_year
      ], unique: true, name: 'upenn_enrollments_uid'

    add_index :gate_count_card_swipes, :swipe_date
  end
end
