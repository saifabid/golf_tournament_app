Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  post 'users/new' => "users#create"
  post 'users/edit' => "users#update"

  resources :tournaments do
    resources :tournament_events
    resources :tournament_tickets
    resources :tournament_sponsorships
  end

  get 'tournament/uploadimages' => 'tournaments#uploadimages'
  resources :signup, :except => [:show]
  get 'signup/download_ticket/:person_id' => 'signup#download_ticket'
  get 'signup/signup_summary/:transaction_id'=> 'signup#signup_summary'
  resources :charges
  get 'signup/signup_summary/:transaction_id'=> 'signup#signup_summary'
  resources :organizer_dashboard
  post'organizer_dashboard/:id/player/:player_id/check_in' => 'organizer_dashboard#check_player_in'

  get 'signup/:id', to: 'signup#signup_from_tournament'

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

  # post 'users/edit' => 'accounts#create'

  # get 'users/account'

  # get 'users/forgot_password'

  # post 'users/forgot_password'

  get 'tournaments/:id/private_event_login', to: 'tournaments#private_event_login'

  post 'tournaments/:id/private_event_login', to: 'tournaments#private_event_login'

  get 'tournaments/:id/private_event_login_fail', to: 'tournaments#private_event_login_fail'

  get 'tournaments/:id/check_in', to: 'tournaments#check_in'

  get 'tournaments/:id/check_in_fail', to: 'tournaments#check_in_fail'

  get 'tournaments/:id', to: 'tournaments#show'

  get 'tournament_stats/:id', to: 'tournament_stats#show'

  get 'tournaments/:id/edit', to: 'tournaments#edit'

  get 'tournaments/:id/guest_login', to: 'tournaments#guest_login'

  post 'tournaments/:id/guest_login', to: 'tournaments#guest_login'

  get 'tournaments/:id/guest_login_fail', to: 'tournaments#guest_login_fail'

  get 'tournaments/:id/schedule', to: 'tournaments#schedule'

  get 'dashboard/index'

  get 'charges/new'

  get 'dashboard/participatingtournaments_feed'
  get 'dashboard/createdtournaments_feed'

  root to: 'welcome#hello_world'

  # get 'tournament_registration/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
