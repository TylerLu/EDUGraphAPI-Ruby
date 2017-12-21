Rails.application.routes.draw do
  root to: 'account#index'

  # oauth2
  get 'auth/azure_oauth2', as: :azure_auth
  match 'auth/azure_oauth2/callback', to: 'account#azure_oauth2_callback', via: [:get, :post]
  match 'link/login_o365_callback', via: [:get, :post]
  match 'admin/consent_callback', via: [:get, :post]

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
  post 'link/login_o365'
  post 'link/relogin_o365'  

  # admin
  get 'admin' => 'admin#index'
  get 'admin/index'
  get 'admin/consent'
  get 'admin/linked_accounts'
  get 'admin/unlink_account/:id' => 'admin#unlink_account'
  post 'admin/consent' => 'admin#consent_post'
  post 'admin/unconsent'
  post 'admin/add_app_role_assignments'
  post 'admin/unlink_account/:id' => 'admin#unlink_account_post'
  post 'admin/clear_adal_cache'

  # manage
  get 'manage/aboutme'
  post 'manage/update_favorite_color'
  


  # schools
  resources :schools, only: :index do
    resources :classes do
      collection do
        get :more        
      end
      member do
        post :save_seating_positions
        post :add_coteacher
      end
    end
  end

post '/classes/newassignment'
end