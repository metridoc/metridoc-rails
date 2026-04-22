Rails.application.routes.draw do

  get 'report_gallery/' => "report_gallery#index"
  get 'report_gallery/pcc', :to => redirect('pennCountryCollaborators.html')
  get 'report_gallery/wpp', :to => redirect('worldPennPublished-2.html')
  get 'report_gallery/wwp', :to => redirect('wosWorldPublishers-1.html')
  get 'report_gallery/psc', :to => redirect('pennStateCollaborators.html')
  get 'library_facts/' => "library_facts#index"
  get 'library_facts/factbook_2020', :to => redirect('FACTS2020.epub')
  get 'library_facts/factbook_2023', :to => redirect('PENN_LIBRARIES_FACTS_2023.pdf')

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#home'

  get 'shib', to: 'single_sign_on#shib'
  get 'logout', to: 'single_sign_on#logout'
  get 'sso', to: 'single_sign_on#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
