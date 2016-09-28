Rails.application.routes.draw do
  # get 'users/index'

  # get 'users/new'

  # get 'users/create'

  # get 'users/show'

  # get 'users/edit'

  # get 'users/update'

  # get 'users/destroy'

  # get 'tournament_registration/index'

  post 'users/signin'

  get 'users/account'

  get 'users/forgot_password'

  # post 'users/forgot_password'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'
end
