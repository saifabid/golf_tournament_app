Rails.application.routes.draw do
  get 'about/contact'

  get 'about/company'

  get 'about/features'

  get 'about/faq'

  get 'about/partners'

  get 'legal/site_map'

  get 'legal/terms_of_service'

  get 'legal/privacy'

  resource :tournaments
  get 'dashboard/index'

  post 'welcome/hello_world'
  get "welcome/hello_world" => "welcome#hello_world"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#hello_world'
end
