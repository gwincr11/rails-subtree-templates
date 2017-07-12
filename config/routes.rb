require 'flipper'
require 'flipper-ui'


Rails.application.routes.draw do
  mount Flipper::UI.app(->() { Flipper::Rails.flipper }) => '/flipper'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/logout'                  => 'sessions#logout',  :as => "logout"
  get '/auth/githubber/callback' => 'sessions#create',  :as => "oauth_callback"

  # This should go last in here because it will match everythingggg
  get "/*page", to: "pages#index", :requirements => { page: /.+/ }

  root to: 'pages#index'
end
