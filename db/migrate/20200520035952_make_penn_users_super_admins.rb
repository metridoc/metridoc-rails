class MakePennUsersSuperAdmins < ActiveRecord::Migration[5.2]
  def change
    AdminUser.where(" email like '%@upenn.edu' ").update_all(super_admin: true)
  end
end
