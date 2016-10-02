Rails.application.routes.draw do

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

  # post 'users/signin'

  get 'users/account'

  get 'users/forgot_password'

  post 'users/forgot_password'

  resources :users

  resource :tournaments
  get 'dashboard/index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'
end
