Rails.application.routes.draw do
  root to: 'account#index'

  # oauth2
  get 'auth/azure_oauth2', as: :azure_auth
  match 'auth/azure_oauth2/callback', to: 'account#azure_oauth2_callback', via: [:get, :post]
  match 'link/azure_oauth2/callback' => 'link#azure_oauth2_callback', via: [:get, :post]
  match 'admin/azure_oauth2/callback' => 'admin#azure_oauth2_callback', via: [:get, :post]

  # account
  get 'account/index'
  get 'account/login'
  get 'account/reset'
  get 'account/register'  
  post 'account/login_o365'
  post 'account/login_local'
  post 'account/register' => 'account#register_post'
  match 'account/logoff', via: [:get, :post]

  get 'users/:id/photo' => 'account#photo'

  # link
  get 'link' => 'link#index'
  get 'link/index'  
  get 'link/create_local'
  get 'link/login_local'
  get 'link/login_o365_required'
  post 'link/matched_local' 
  post 'link/login_local' => 'link#login_local_post'
  post 'link/create_local' => 'link#create_local_post'
  post 'link/login_O365'

  # admin
  get 'admin/consent'
  get 'admin/linked_accounts'
  post 'admin/consent'
  post 'admin/unconsent'
  post 'admin/add_app_role_assignments'
  match 'admin/unlink_account', via: [:get, :post]

  # manage
  get 'manage/about'
  post 'manage/update_favorite_color'
  

  # schools
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

end