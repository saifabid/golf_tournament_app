Rails.application.routes.draw do
  get 'tournament_registration/index'

  get 'welcome' => 'welcome#hello_world'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'

end
