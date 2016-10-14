Rails.application.routes.draw do
  get 'credit_card/index'

  get 'about/contact'

  get 'about/company'

  get 'about/features'

  get 'about/faq'

  get 'about/partners'

  get 'legal/site_map'

  get 'legal/terms_of_service'

  get 'legal/privacy'

  post 'welcome/hello_world'
  get "welcome/hello_world" => "welcome#hello_world"

  devise_for :users, controllers: { registrations: "users/registrations" }

  # authenticated :user do
  #   root 'users#account', as: :authenticated_root
  # end
  # get 'users/index'

  # get 'users/new'

  # get 'users/create'

  # get 'users/show'

  # get 'users/edit'

  # get 'users/update'

  # get 'users/destroy'

  # get 'tournament_registration/index'

  post 'users/edit' => 'accounts#create'

  get 'users/account'

  get 'users/forgot_password'

  post 'users/forgot_password'

  resources :users
  resources :tournaments do
    resources :tournament_events
    resources :tournament_tickets
  end
  resources :signup

  resources :charges
  # resource :tournies

  get 'tournaments/:id', to: 'tournaments#show'
  get 'tournament_stats/:id', to: 'tournament_stats#show'

  get 'dashboard/index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'
end
