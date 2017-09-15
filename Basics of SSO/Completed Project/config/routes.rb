Rails.application.routes.draw do
  root to: 'account#index'

#oauth2
get 'auth/azure_oauth2', as: :azure_auth
match 'auth/azure_oauth2/callback', to: 'account#azure_oauth2_callback', via: [:get, :post]

  # account
  get 'account/index'
  get 'account/login'
  get 'account/register'  
  post 'account/login_o365'
  post 'account/login_local'
  post 'account/register' => 'account#register_post'
  match 'account/logoff', via: [:get, :post]
 
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

  	member do
  	  get :users
      get :users_next
  	end
  end
  
end