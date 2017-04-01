Rails.application.routes.draw do

  resources :admin, only: :index do 
    collection do 
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
      post :next_class
      get 'classes/:class_id' => 'schools#class_info'
  	  get :users
      post :next_users
  	end

    collection do 
      post :save_settings
    end
  end

  match '/Account/Callback' => 'account#callback', via: [:get, :post]

  resources :account, only: [:index] do 
  	collection do 
  		get :login
  		post :login_account
			get :register
			post :externalLogin

			post :register_account
			post :callback
			post :logoff
			get :o365login
  	end
  end

  resources :link, only: [:index, :create] do
    collection do
      post :loginO365
      # post :processcode
      post :link_to_local_account
      get :login_local
      match :create_local_account, via: [:get, :post]
    end
  end
  
end
