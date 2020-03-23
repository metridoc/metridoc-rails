ActiveAdmin.register Security::UserRoleSection, as: "UserRoleSection" do
  belongs_to :user_role, class_name: "Security::UserRole"

  menu false

end
