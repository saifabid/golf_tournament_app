Rails.application.routes.draw do

  resources :sheets

  mount RailsAdmin::Engine => '/db_admin', as: 'rails_admin'
  get 'tournament_list/list'
  post 'tournament_list/list'

  devise_for :users, :controllers => { :registrations => "users/registrations", :sessions => "users/sessions", :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  post 'users/new' => "users#create"
  post 'users/edit' => "users#update"

  resources :tournaments do
    resources :tournament_events
    resources :tournament_tickets
    resources :tournament_sponsorships
    resources :tournament_features
    resources :tournament_profile_pictures
    resources :tournament_sponsorships
  end

  resources :organizer_payment

  get 'tournament/uploadimages' => 'tournaments#uploadimages'
  resources :signup, :except => [:show]
  get 'signup/download_ticket/:person_id' => 'signup#download_ticket'
  get 'signup/signup_summary/:transaction_id'=> 'signup#signup_summary'

  post 'signup/before_payment_summary'=> 'signup#before_payment_summary'
  resources :charges
  get 'signup/signup_summary/:transaction_id'=> 'signup#signup_summary'
  resources :organizer_dashboard
  post'organizer_dashboard/:id/player/:player_id/check_in' => 'organizer_dashboard#check_player_in'
  post'organizer_dashboard/:id/player/:player_id/check_out' => 'organizer_dashboard#check_player_out'
  post'organizer_dashboard/:id/player/:player_id/status/admin/accept' => 'organizer_dashboard#set_player_admin'
  post'organizer_dashboard/:id/player/:player_id/status/admin/reject' => 'organizer_dashboard#remove_player_admin'
  post'organizer_dashboard/:id/player/:player_id/email' => 'organizer_dashboard#send_player_email'
  post'organizer_dashboard/:id/player/:player_id/ticket' => 'organizer_dashboard#send_player_email_ticket'

  post'organizer_dashboard/sendpassword/:id' => 'organizer_dashboard#send_password'

  post'/tournaments/sponsorshipopportunites/:id' => 'tournaments#sponsor_signup'

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

  post 'organizer_dashboard/:id' => 'organizer_dashboard#view_public'
  post 'tournaments/:id' => 'tournaments#return_to_org_dash'

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

  get 'tournaments/:id/venue_information', to: 'tournaments#venue_information'

  get 'tournaments/:id/features', to: 'tournaments#features'

  get 'tournaments/:id/sponsors', to: 'tournaments#sponsors'

  get 'tournaments/:id/edit_tournament_features/', to: 'tournament_features#edit_features'

  get 'dashboard/index'

  get 'dashboard/participatingtournaments_feed'
  get 'dashboard/createdtournaments_feed'
  get 'dashboard/spectatortournaments_feed'
  get 'dashboard/sponsoredtournaments_feed'
  get 'charges/new'
  get 'dashboard/my_orders'


  root to: 'welcome#hello_world'

  # get 'tournament_registration/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
