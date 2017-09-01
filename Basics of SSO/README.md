# Basic SSO - Ruby version

In this sample we show you how to integrate Azure Active Directory(Azure AD) to provide secure sign in and authorization. 

The code in the following sections is part of the full featured Ruby app and presented as a new project for clarity and separation of functionality.

**Table of contents**
* [Register the application in Azure Active Directory](#register-the-application-in-azure-active-directory)
* [Prerequisites](#prerequisites)
* [Build and debug locally](#build-and-debug-locally)


## Register the application in Azure Active Directory

1. Sign in to the Azure portal: [https://portal.azure.com/](https://portal.azure.com/).

2. Choose your Azure AD tenant by selecting your account in the top right corner of the page.

3. Click **Azure Active Directory** -> **App registrations** -> **+Add**.

4. Input a **Name**, and select **Web app / API** as **Application Type**.

   Input **Sign-on URL**: https://localhost:44377/

   ![](Images/aad-create-app-02.png)

   Click **Create**.

5. Once completed, the app will show in the list.

   ![](Images/aad-create-app-03.png)

6. Click it to view its details. 

   ![](Images/aad-create-app-04.png)

7. Click **All settings**, if the setting window did not show.

     ![](Images/aad-create-app-05.png)

     Copy aside **Application ID**, then Click **Save**.

   * Click **Reply URLs**, add the following URL into it.

     [http://localhost:3000/auth/azure_oauth2/callback](http://localhost:3000/auth/azure_oauth2/callback)

   * Click **Required permissions**. Add the following permissions:

     | API                            | Application Permissions | Delegated Permissions         |
     | ------------------------------ | ----------------------- | ----------------------------- |
     | Windows Azure Active Directory |                         | Sign in and read user profile |

     ![](Images/aad-create-app-06.png)

   * Click **Keys**, then add a new key

     ![](Images/aad-create-app-07.png)

     Click **Save**, then copy aside the **VALUE** of the key. 

   Close the Settings window.



## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/Download).
- The [Ruby](https://www.ruby-lang.org/en/downloads) language version 2.2.2 or newer.
- The [RubyGems](https://rubygems.org/) packaging system, which is installed with Ruby by default. To learn more about RubyGems, please read the [RubyGems Guides](http://guides.rubygems.org/).
- The [Rails](http://rubyonrails.org/) web application development framework, version 5.0.0 or above
- A working installation of the [SQLite3 Database](https://www.sqlite.org/).
  ​

## Build and debug locally

1.  Open a terminal, navigate to a directory where you have rights to create files, and type 

      `$ rails new basicsso`

      ![](Images/new-project-01.png)                                      

2. This will create a Rails application called **basicsso** in directory.

3. Close terminal window, use vscode open **basicsso** folder.

   ![](Images/new-project-02.png)

4. Open **Gemfile** file, delete all code and  add the following code into it.

   ```Ruby
   source 'https://rubygems.org'
   gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
   gem 'mysql2'
   gem 'sqlite3'
   gem 'puma', '~> 3.0'
   gem 'sass-rails', '~> 5.0'
   gem 'uglifier', '>= 1.3.0'
   gem 'jquery-rails'
   gem 'turbolinks', '~> 5'
   gem 'jbuilder', '~> 2.5'
   gem 'bcrypt', '~> 3.1.7'
   gem 'microsoft_graph'
   gem 'adal'
   gem 'config'
   gem 'httparty'
   gem 'openid_connect'
   gem 'omniauth-oauth2'
   gem 'activerecord-session_store'
   group :development, :test do
     gem 'byebug', platform: :mri
   end
   group :development do
     gem 'web-console'
     gem 'listen', '~> 3.0.5'
     gem 'spring'
     gem 'spring-watcher-listen', '~> 2.0.0'
   end
   gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
   ```

5.  Open **basicsso/app/assets/javascripts** folder, add new file named **site.js** into it.

6. Open **site.js**  and  add the following code into it.

   ```ruby
   $(document).ready(function () {
       $("#userinfolink").click(function (evt) {
           evt.stopPropagation ? evt.stopPropagation() : evt.cancelBubble = true;
           $("#userinfoContainer").toggle();
           $("#caret").toggleClass("transformcaret");
       });
       $(document).click(function () {
           $("#userinfoContainer").hide();
           $("#caret").removeClass("transformcaret");

       });
   });
   ```

7. Open **basicsso/app/assets/javascripts/application.js** file, delete all code and add the following code into it.

   ```ruby
   //= require jquery
   //= require jquery_ujs
   //= require turbolinks
   // require_tree .
   ```

8. Open **basicsso/app/assets/stylesheets** folder, add the following files into it.

   - **bootstrap.css**
   - **site.css**

9. Download **[bootstrap](https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css)** style file, copy all content into **bootstrap.css** file that created above step and save.

10. Open **site.css** file, delete all code and add the following code into it.

   ```css
   html{height:100%;}
   body {padding-top: 50px;padding-bottom: 20px;background-repeat: no-repeat;background-size: 100%     100%;height:100%;}
   .body-content {padding-left: 15px;padding-right: 15px;height:100%;}
   .containerbg{height:100%;}
   .loginbody{margin:auto;padding:110px 15px 0 15px;max-width:1200px;}
   .loginbody > .row{padding:0 20px 0 65px;}
   #loginForm a{color:#4B67F8;font-size:16px;}
   .navbar-inverse{background-color:#127605;border-color:#127605;}
   .navbar-inverse .navbar-brand, 
   .navbar-inverse .navbar-nav > li > a {color:white;}
   .navbar-inverse .navbar-brand{font-size:14px}
   .container>div.row{height:auto;background-color:#fff;}
   .container.body-content{height:100%; background-color:#fff;}
   .navbar-right a{color:white;text-decoration:none;}
   .userinfo .caret{color:white;font-size:20px;}
   .transformcaret{transform: rotate(180deg);}
   .userinfo{height:50px;line-height:50px;}
   .popupcontainer{display:none;}
   .navbar-collapse{position:relative;}
   .popuserinfo{position:absolute;top:40px;z-index:999;background-color:white;padding:15px 0;width:200px;border:1px solid #dedede;box-sizing: border-box;left:955px;}
   .subitem{float:left;width:100%;}
   .subitem a{color:black;text-decoration:none;width:100%;height:100%;display:block;padding:10px 0 10px 20px;}
   .subitem:hover{background-color:#127605;color:white;}
   .subitem a:hover{color:white;}
   .container {width: 1170px;}
   ```

11. Open **application.css** file, delete all code and add the following code into it.

    ```ruby
    /*
     *
     *= require bootstrap
     *= require site
     *= require_self
     */
    ```

12. Open **basicsso/app/helpers/application_helper.rb** file, delete all code and add the following code into it.

    ```ruby
    require 'fileutils'

    module ApplicationHelper

      def full_host
        if request.scheme && request.url.match(URI::ABS_URI)
          uri = URI.parse(request.url.gsub(/\?.*$/, ''))
          uri.path = ''
          uri.scheme = 'https' if ssl?
          uri.to_s
          else ''
        end
      end

      def ssl?
        request.env['HTTP_X_ARR_SSL'] ||
          request.env['HTTPS'] == 'on' ||
          request.env['HTTP_X_FORWARDED_SSL'] == 'on' ||
          request.env['HTTP_X_FORWARDED_SCHEME'] == 'https' ||
          (request.env['HTTP_X_FORWARDED_PROTO'] && request.env['HTTP_X_FORWARDED_PROTO'].split(',')[0] == 'https') ||
          request.env['rack.url_scheme'] == 'https'
      end

    end
    ```

13. Open **basicsso/config** folder, add new file named **settings.yml**, add the following code into it.

    ```ruby
    AAD:
      ClientId: <%= ENV['ClientId'] %>
      ClientSecret: <%= ENV['ClientSecret'] %>
    ```

    ​

14. Open **basicsso/config/application.rb** file,  delete all code and add the following code into it.

    ```ruby
    require_relative 'boot'
    require 'rails/all'

    Bundler.require(*Rails.groups)
    module EDUGraphAPIRuby
      class Application < Rails::Application
        config.eager_load_paths += %W(#{config.root}/lib)
      end
    end
    ```

15. Open **basicsso/config/initializers** folder, add the following files into it.

    - **omniauth.rb**
    - **session_store.rb**

16. Open **omniauth.rb** file,  add the following code into it.

    ```ruby
    module OmniAuth
      module Strategies
        autoload :AzureOAuth2, Rails.root.join('lib', 'omniauth', 'strategies', 'azure_oauth2') 
      end
    end

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :AzureOAuth2, {
        client_id: Settings.AAD.ClientId, 
        client_secret: Settings.AAD.ClientSecret, 
        provider_ignores_state: true,
        callback_paths: [ 
          '/auth/azure_oauth2/callback'
        ]
      }
    end
    ```

17. Open **session_store.rb** file,  add the following code into it.

    ```ruby
    Rails.application.config.session_store :active_record_store, key: '_EDUGraphAPI_ruby_session'
    ```

18. Open **basicsso/config/initializers/assets.rb** file,  delete all code and add the following code into it.

    ```ruby
    Rails.application.config.assets.version = '1.0'
    Rails.application.config.assets.precompile += %w( 
    site.js
    )
    ```

19. Open **basicsso/lib** folder, add a new file named **exceptions.rb**, add the following code into it.

    ```ruby
    module Exceptions
      class RefreshTokenError < StandardError; end
    end
    ```

20. Open **basicsso/lib** folder, add a new folder named **omniauth**, open **omniauth** folder, add a new folder named **strategies**.

21. Open **strategies** folder, add new file named **azure_oauth2.rb** into it,  add the following code into it.

    ```ruby
    require 'omniauth/strategies/oauth2'
    require 'jwt'

    module OmniAuth
      module Strategies

        class AzureOAuth2 < OmniAuth::Strategies::OAuth2

          BASE_AZURE_URL = 'https://login.microsoftonline.com'

          option :name, 'azure_oauth2'
          option :tenant_id, 'common'
          option :resource, 'https://graph.windows.net'
          option :callback_paths, []

          args [:tenant_id]

          def client
            
            options.client_id = options.client_id
            options.client_secret = options.client_secret
            options.tenant_id = options.tenant_id

            options.callback_path = request.params['callback_path'] if request.params['callback_path']

            options.authorize_params.prompt = request.params['prompt'] if request.params['prompt']
            options.authorize_params.login_hint = request.params['login_hint'] if request.params['login_hint']   

            options.client_options.authorize_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/authorize"
            options.client_options.token_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/token"

            options.token_params.resource = options.resource

            super
          end

          uid {
            raw_info['sub']
          }

          info do
            {
              name: raw_info['name'],
              nickname: raw_info['unique_name'],
              first_name: raw_info['given_name'],
              last_name: raw_info['family_name'],
              email: raw_info['email'] || raw_info['upn'],
              oid: raw_info['oid'],
              tid: raw_info['tid']
            }
          end

          def callback_url
            full_host + script_name + callback_path
          end

          def raw_info
            # it's all here in JWT http://msdn.microsoft.com/en-us/library/azure/dn195587.aspx
            @raw_info ||= ::JWT.decode(access_token.token, nil, false).first
          end

          def on_callback_path?
            options[:callback_paths].include? current_path or super
          end

          protected

          def build_access_token
            options.callback_path = current_path
            super
          end

          def ssl?
            request.env['HTTP_X_ARR_SSL'] || super
          end

        end
      end
    end
    ```

22. Open **app/controllers/application_controller.rb** file, delete all code and  add the following code into it.

    ```typescript
    class ApplicationController < ActionController::Base

      before_action :convert_ssl_header
      around_action :handle_refresh_token_error

      include ApplicationHelper
      helper_method :current_user

      def current_user
        session['_o365_user']
      end

      def set_o365_user(o365_user)
        session['_o365_user'] = o365_user
      end

      def token_service
        @token_service ||= TokenService.new
      end

      def set_session_expire_after(days)
        session.options[:expire_after] = 60 * 60 * 24 * days
      end

      def clear_session_expire_after
        session.options[:expire_after] = nil 
      end

      def handle_refresh_token_error
        begin
          yield
        rescue Exceptions::RefreshTokenError => exception
          redirect_to link_login_o365_required_path
        end
      end

      def azure_oauth2_logout_required
        session['azure_logout_required']
      end

      def azure_oauth2_logout_required=(value)
        session['azure_logout_required'] = value
      end

      def convert_ssl_header
        if request.headers['HTTP_X_ARR_SSL']
          request.headers['HTTP_X_FORWARDED_SCHEME'] = 'https'
        end
      end

    end
    ```

23. Add new file named **account_controller.rb** into **app/controllers/** folder,  add the following code into it.

    ```typescript
    class AccountController < ApplicationController
      
      def index
      end

      def login_o365
         redirect_to azure_auth_path
      end

      def azure_oauth2_callback
        auth = request.env['omniauth.auth']

        # cahce tokens
        token_service.cache_tokens(auth.info.oid, Constants::Resources::AADGraph, 
        auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)
        set_o365_user(auth.info.email)

        self.azure_oauth2_logout_required = true
        redirect_to account_index_path
      end
       def logoff
        azure_oauth2_logout_required = self.azure_oauth2_logout_required 

        session.clear
        reset_session()
        clear_session_expire_after()

        if azure_oauth2_logout_required 
          post_logout_redirect_uri = URI.escape("#{full_host}/account/index", Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
          logoff_url = "#{Constants::AADInstance}common/oauth2/logout?post_logout_redirect_uri=#{post_logout_redirect_uri}"
          redirect_to logoff_url
        else
          redirect_to account_login_path 
        end   
      end

    end
    ```

24. Open **app/views/layouts/application.html.erb** file, delete all code and  add the following code into it.
    ```html
        <!DOCTYPE html>
        <html>
          <head>
            <title><%= content_for?(:title) ? yield(:title) : 'EDUGraphAPI' %></title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <%= csrf_meta_tags %>
            <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
            <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
          </head>
          <body>
          	<div class="navbar navbar-inverse navbar-fixed-top">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="/">Basic SSO</a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <%= yield :user_login_info %>
                    </div>
                </div>
            </div>
            <div class="containerbg">
                <div class="container body-content">
                    <%= yield %>
                    <%= javascript_include_tag 'site' %>
                    <footer></footer>
                </div>
            </div>
            </div>
          </body>
        </html>
    ```

25. Add new folder named **account** into **app/views** folder,  

26. Add new file named **index.html.erb** into **app/views/account** folder, add the following code into it.

    ```html
    <%= content_for :title, 'Log in - Basic SSO' %>
    <% if current_user %>
        <% content_for :user_login_info do %>
            <form action="/account/logoff" class="navbar-right" id="logoutForm" method="post">
                <div class="userinfo">
                <a href="javascript:void(0);" id="userinfolink"> Hello <%= current_user %>
                    <span class="caret" id="caret"></span>
                </a>
                </div>
                <div class="popupcontainer" id="userinfoContainer">
                <div class="popuserinfo">
                    <div class="subitem">
                        <a href="javascript:document.getElementById('logoutForm').submit()">Log off</a>
                    </div>
                </div>
                </div>
            </form>
        <% end %>
    <% end %>

    <div class="loginbody">
        <div class="row">
            <div class="col-md-5">
                <section id="socialLoginForm">
                <% if current_user %>
                    <h1>Hello World!</h1>
                <% else %>
                    <form action="/account/login_o365" method="post">
                        <div id="socialLoginList">
                            <p><button type="submit" class="btn btn-default btn-ms-login" id="OpenIdConnect" name="provider" value="OpenIdConnect">Sign In With Office 365</button></p>
                        </div>
                    </form>
                <% end %>
                </section>
            </div>
        </div>
    </div>
    ```

27. Add new file named **schema.rb** into **db** folder, add the following code into it to create token cache table.

    ```Ruby
    ActiveRecord::Schema.define(version: 20170501145528) do
      create_table "sessions", force: :cascade do |t|
        t.string   "session_id", null: false
        t.text     "data"
        t.datetime "created_at"
        t.datetime "updated_at"
        t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
        t.index ["updated_at"], name: "index_sessions_on_updated_at"
      end

      create_table "token_caches", force: :cascade do |t|
        t.datetime "created_at",                     null: false
        t.datetime "updated_at",                     null: false
        t.string   "o365_userId"
        t.text     "refresh_token"
        t.text     "access_tokens"
      end

    end
    ```

28. Add new file named **token_cache.rb** into **app/models** folder, add the following code into it to create token cache model.

    ```Ruby
    class TokenCache < ApplicationRecord
    end
    ```

29. Add new file named **constants.rb** into **app/models** folder, add the following code into it .

    ```ruby
    module Constants

      AADInstance = "https://login.microsoftonline.com/"

      module Resources
        MSGraph = 'https://graph.microsoft.com' 
        AADGraph = 'https://graph.windows.net'
      end

    end
    ```

30. Add new folder named **services** into **app** folder.

31. Add new file named **token_service.rb** into **app/services** folder, add the following code into it.

    ```ruby
    class TokenService
        
      def initialize()
      end

      def cache_tokens(o365_user_id, resource, refresh_token, access_token, jwt_exp)
        cache = TokenCache.find_or_create_by(o365_userId: o365_user_id)
        cache.refresh_token = refresh_token
        access_tokens = cache.access_tokens ? JSON.parse(cache.access_tokens) : {}
        access_tokens[resource] = { 
          expiresOn: get_expires_on(jwt_exp), 
          value: access_token 
        }
        cache.access_tokens = access_tokens.to_json();
        cache.save();
      end

      def get_access_token(o365_user_id, resource)
        cache = TokenCache.find_by_o365_userId(o365_user_id)
        if !cache
          raise Exceptions::RefreshTokenError
        end
        # parse access_tokens
        access_tokens = JSON.parse(cache.access_tokens)
        access_token = access_tokens[resource]
        if access_token
          expires_on = DateTime.parse(access_token['expiresOn'])
          utc_now = DateTime.now.new_offset(0)
          if utc_now < expires_on - 5.0 / 60 / 24
            return access_token['value']
          end
        end
        # refresh token and cache
        auth_result = refresh_token(cache.refresh_token, resource)
        access_tokens[resource] = { 
          expiresOn: get_expires_on(auth_result.expires_on), 
          value: auth_result.access_token }
        cache.access_tokens = access_tokens.to_json()
        cache.refresh_token = auth_result.refresh_token
        cache.save()
        #
        return auth_result.access_token;
      end

      def clear_token_cache
        caches = TokenCache.all();
        caches.each do |cache|
          cache.destroy()
        end
      end

      private def refresh_token(refresh_token, resource)
    		authentication_context = ADAL::AuthenticationContext.new
    		client_credential = ADAL::ClientCredential.new(Settings.AAD.ClientId, Settings.AAD.ClientSecret)
        begin
           authentication_context.acquire_token_with_refresh_token(refresh_token, client_credential, resource)
        rescue
          raise Exceptions::RefreshTokenError
        end
      end

      private def get_expires_on(jwt_exp)
        return DateTime.new(1970, 1, 1) + jwt_exp * 1.0 / (60 * 60 * 24)
      end

    end
    ```

32. Open **config/routes.rb** file, delete all code and add the following code into it .

    ```ruby
    Rails.application.routes.draw do
      root to: 'account#index'

      # oauth2
      get 'auth/azure_oauth2', as: :azure_auth
      match 'auth/azure_oauth2/callback', to: 'account#azure_oauth2_callback', via: [:get, :post]

      # account
      get 'account/index'
      get 'account/login'
      post 'account/login_o365'
      match 'account/logoff', via: [:get, :post]

    end
    ```

33. Delete the file named **Gemfile.lock** in the root folder of **basicsso**.

34. Open a terminal, navigate to **basicsso** directory again. 

35. Type the following command to set ClientId and ClientSecret and run

    ```rails
    export ClientId=INSERT YOUR CLIENT ID HERE

    export ClientSecret=INSERT YOUR CLIENT SECRET HERE
    ```

      **clientId**: use the Client Id of the app registration you created earlier.

      **clientSecret**: use the Key value of the app registration you created earlier.

36. Type the following command to install bundle and run.

    ```rails
    bundle install
    ```


37. Type the following command to create table and run.

    ```rails
    rails db:schema:load
    ```


38. Type the following command to run server.

    ```rails
    rails s
    ```

39. Open a browser window and navigate to [http://localhost:3000](http://localhost:3000/).

40. Press F5, click **Sign In with Office 365** button to sign in.

    ![](Images/new-project-04.png)

41. Hello world page is presented after login successfully. 

    ![](Images/web-app-helloworld.png)


**Copyright (c) 2017 Microsoft. All rights reserved.**
