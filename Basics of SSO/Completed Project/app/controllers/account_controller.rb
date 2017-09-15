class AccountController < ApplicationController
  
  def index
    url = ''
    if !current_user.is_authenticated?
      url = '/account/login'
    else
      url = '/schools'
    end
    redirect_to url
  end

  def login
    render 'login'
  end


  def login_o365
     redirect_to azure_auth_path
  end

  def azure_oauth2_callback
    auth = request.env['omniauth.auth']

    # cahce tokens
    token_service.cache_tokens(auth.info.oid, Constants::Resources::AADGraph, 
      auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)

    # o365 user
    o365_user = O365User.new(auth.info.oid, auth.info.email, auth.info.first_name, auth.info.last_name,  auth.info.tid)
    set_o365_user(o365_user)


    clear_session_expire_after()
    self.azure_oauth2_logout_required = true
    redirect_to account_index_path
  end

  def login_local
    user_service = UserService.new
    user = user_service.authenticate(params["Email"], params["Password"])
    if !user
      redirect_to account_login_path, alert: 'Invalid login attempt.' and return
    end

    if params[:RememberMe]
      set_session_expire_after(30)
    else
      clear_session_expire_after()
    end

    set_local_user(user)
    
    redirect_to account_index_path
  end

  def register
  end

  def register_post
    user_service = UserService.new
    user = user_service.get_user_by_email(params["Email"])
    if user
      flash[:alert] = "Email #{params['Email']} is already taken"
        render 'register' and return
    end

    user = user_service.register(params["Email"], params["Password"])
    set_local_user(user)
    redirect_to account_index_path
  end


  def logoff
    azure_oauth2_logout_required = self.azure_oauth2_logout_required 

    session.clear
    reset_session()
    clear_session_expire_after()

    if azure_oauth2_logout_required 
      post_logout_redirect_uri = URI.escape("#{full_host}/account/login", Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      logoff_url = "#{Constants::AADInstance}common/oauth2/logout?post_logout_redirect_uri=#{post_logout_redirect_uri}"
      redirect_to logoff_url
    else
      redirect_to account_login_path 
    end   
  end

end