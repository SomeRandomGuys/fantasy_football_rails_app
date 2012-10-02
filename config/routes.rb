FantasyFootball::Application.routes.draw do
  
  apipie
  
  #get "sessions/new"
  resource :sessions, :only => [:new, :create, :destroy]
  resource :users, :only => [:new, :create]
  resource :fantasy_league
  resource :fantasy_manager
  resource :fantasy_team
  resource :player
  
  ######## Write Stats API ########
  resources :api do
    collection do
      get 'show'
      post 'new_match'
      post 'match_team_stats'
      post 'match_player_stats'
    end
  end
  resources :match
  resources :match_player_stats
  resources :match_team_stats

  #################################
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/signup', :to => 'users#new'
  match '/drop_player', :to => 'fantasy_teams#drop_player'
  # match '/show_fantasy_team', :to => 'fantasy_managers#show_fantasy_team'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  root :to => 'home#index'
   match 'new_league' => 'fantasy_leagues#new'
  # match 'list' => 'fantasy_league#list_fantasy_leagues'
  # match 'register_league' => 'fantasy_league#register_league'
   match 'join_league' => 'fantasy_managers#new'
  # match 'new_fantasy_manager' => 'fantasy_league#new_fantasy_manager'
  # match 'list_managers' => 'fantasy_league#list_managers'
#   
  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
