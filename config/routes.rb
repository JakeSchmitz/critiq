Critiq0::Application.routes.draw do

  resources :activities
  resources :password_resets

  resources :products do
    resources :pictures, controller: 'image_assets'
    resources :likes
    post 'pictures/new' => :upload_picture, as: 'pic_upload'
    resources :comments do
      get 'vote' => :vote
    end
    resources :bounties do
      resources :comments do
        get 'vote' => :vote
      end
    end
    resources :feature_groups do 
      resources :features do
        resources :pictures, controller: 'image_assets'
        get 'upvote'  => :upvote
        get 'downvote'  => :downvote
      end
      get 'vote'  => :vote
    end
    #get "feature_groups/new_comparative_feature" => 'feature_groups#new-comparitive-feature-modal'
    get 'grant_access' => :grant_access, as: :access
    get 'love' => :love
    get 'active_switch' => :active_switch
    get 'initial_uploads' => :initial_uploads
  end

  resources :users do
    resources :pictures, controller: 'image_assets'
    post 'pictures/new' => :upload_picture, as: 'pic_upload'
    get 'propic/:image_id/' => :change_profile_picture, as: 'profile_pic'
    get 'dashboard' => :dashboard
    get '/make_creator' => :make_creator, as: 'creator'
    post '/request_creator_status' => :request_creator_status, as: 'request_creator_status'
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :image_assets
  resources :comments do
    get 'vote'  => :vote
  end
  root :to => "pages#home"

  match '/request_creator_status', to: 'users#request_creator_status', via: 'post'
  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'pages#login', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/home', to: 'pages#home', via: 'get'
  match '/contact', to: 'pages#contact', via: 'get'
  match '/community', to: 'pages#community', via: 'get'
  match '/about', to: 'pages#about', via: 'get'
  match '/how_to', to: 'pages#how_to', via: 'get'
  match '/get_started', to: 'pages#how_to', via: 'get'
  match '/auth/facebook/callback', to: 'auth#new_facebook', via: 'get'
  match '/auth/twitter/callback', to: "auth#new_twitter", via: 'get'
  match '/auth/linkedin/callback', to: "auth#new_linkedin", via: 'get'

  post '/twitter_signup', to: 'auth#create_twitter', as: 'twitter_signup' 

  post 'signin', to: 'sessions#create', as: "login"
  get 'signout', to: 'sessions#destroy', via: 'delete'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
