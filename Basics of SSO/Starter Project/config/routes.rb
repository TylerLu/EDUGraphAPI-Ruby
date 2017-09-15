Rails.application.routes.draw do
  root to: 'account#index'

  # account
  get 'account/index'
  get 'account/login'
  get 'account/register'  
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