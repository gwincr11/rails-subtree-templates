Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/logout'                  => 'sessions#logout',  :as => "logout"
  get '/auth/githubber/callback' => 'sessions#create',  :as => "oauth_callback"

  get "/*page", to: "pages#index", :requirements => { page: /.+/ }
  root to: 'pages#index'
end
