class AddIndicesToEnrollmentGatecounts < ActiveRecord::Migration[7.1]
  def change
    rename_column :upenn_enrollments, :user, :user_type

    add_index :upenn_enrollments, [
      :user_type, :school, :fiscal_year
      ], unique: true, name: 'upenn_enrollments_uid'

    add_index :gate_count_card_swipes, :swipe_date
  end
end
