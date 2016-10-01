Rails.application.routes.draw do
  resource :tournaments
  get 'dashboard/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'
end
