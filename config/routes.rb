Rails.application.routes.draw do
  root to: 'account#index'

  resources :admin, only: :index do 
    collection do 
      get :consent
      post :consent
      post :unconsent
      get :linked_accounts
      post :add_app_role_assignments
      match :unlink_account, via: [:get, :post]
    end
  end
  
  resources :manage, only: :index do
    collection do
      get :aboutme
      post :update_favorite_color
    end
  end

  resources :schools, only: :index do
  	member do
  	  get :classes
      post :next_classes
      get 'classes/:class_id' => 'schools#class_info'
  	  get :users
      post :next_users
  	end

    collection do 
      post :save_settings
    end
  end

  get '/auth/azure_oauth2', as: :sign_in
  match '/auth/azure_oauth2/callback', to: 'account#azure_oauth2_callback', via: [:get, :post]

  # match '/Account/Callback' => 'account#callback', via: [:get, :post]

  get '/users/:id/photo', to: 'account#photo'

  resources :account, only: [:index] do 
  	collection do 
  		get :login
      get :reset
			post 'login/o365' => 'account#login_o365'
  		post 'login/local' => 'account#login_local'
			get :register
			post :register_account

			post :callback
			post :logoff
			get :o365login

      get :login_for_admin_consent
      get :local_account_login
  	end
  end


  resources :link, only: [:index, :create] do
    collection do
      post :login_O365
      # post :processcode
      post :create_local_account_post
      post :link_to_local_account
      get :login_local
      get :login_o365_required
      get :relogin_o365
      match :create_local_account, via: [:get, :post]
      match 'azure_oauth2/callback' => 'link#azure_oauth2_callback', via: [:get, :post]
    end
  end
  
end
