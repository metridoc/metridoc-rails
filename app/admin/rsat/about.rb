ActiveAdmin.register_page "About", namespace: :rsat do
  menu false

  content title: "RSAT" do

    unless current_admin_user.authorized?
      redirect_to :admin_root
    end

    render partial: 'index'
  end
end
