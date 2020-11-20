Rails.application.routes.draw do

  get 'report_gallery/' => "report_gallery#index"
  get 'report_gallery/pcc', :to => redirect('pennCountryCollaborators.html')
  get 'report_gallery/wpp', :to => redirect('worldPennPublished-2.html')
  get 'report_gallery/wwp', :to => redirect('wosWorldPublishers-1.html')

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
