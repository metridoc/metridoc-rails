ActiveAdmin.register Security::UserRoleAccessDefinition, as: "UserRoleAccessDefinition" do
  belongs_to :user_role, class_name: "Security::UserRole"

  menu false

end
