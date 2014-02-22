Critiq0::Application.routes.draw do

  resources :activities

  resources :products do
    resources :pictures
    resources :likes
    post 'pictures/new' => :upload_picture, as: 'pic_upload'
    resources :comments do
      get 'upvote' => :upvote
      get 'downvote' => :downvote
    end
    resources :bounties do
      resources :comments do
        get 'upvote' => :upvote
        get 'downvote' => :downvote
      end
    end
    resources :feature_groups do 
      resources :features do
        resources :pictures
        get 'upvote'  => :upvote
        get 'downvote'  => :downvote
      end
      get 'vote'  => :vote
    end
    #get "feature_groups/new_comparative_feature" => 'feature_groups#new-comparitive-feature-modal'
    get 'love' => :love
    get 'active_switch' => :active_switch
  end

  resources :users do
    resources :pictures 
    post 'pictures/new' => :upload_picture, as: 'pic_upload'
    get 'propic/:image_id/' => :change_profile_picture, as: 'profile_pic'
    get 'dashboard' => :dashboard
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :image_assets

  root :to => "pages#home"

  match '/signup', to: 'users#new', via: 'get'
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/home', to: 'pages#home', via: 'get'
  match '/contact', to: 'pages#contact', via: 'get'

  post 'signin', to: 'sessions#create'
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
