class AddParentsToUpennEnrollments < ActiveRecord::Migration[5.2]
  def change
    add_column :upenn_enrollments, :user_parent, :string
    add_column :upenn_enrollments, :school_parent, :string
  end
end
