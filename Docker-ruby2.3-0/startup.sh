#!/bin/bash

if [ -n "$SECRET_KEY_BASE" ]
  then
    echo 'Secret key base present'
  else
    echo 'Generating a secret key base'
    export SECRET_KEY_BASE=$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')
fi

if [ -n "$RAILS_ENV" ]
  then
    echo 'RAILS_ENV set to $RAILS_ENV'
  else
    echo 'RAILS_ENV not set, default to production'
    export RAILS_ENV='production'
fi

if [ -d /home/site/wwwroot ] && [ ! -e /home/site/wwwroot/hostingstart.html ] 
  then
    echo '/home/site/wwwroot'
    cd /home/site/wwwroot
  else
    echo '/opt/splash/splash'
    cd /opt/splash/splash
fi

echo 'Removing any leftover pids if present'
rm -f tmp/pids/* ;

if [ -n "$APP_COMMAND_LINE" ]
  then
    echo 'using command: $APP_COMMAND_LINE'
    echo 'Executing $APP_COMMAND_LINE'
    $APP_COMMAND_LINE
  else
    echo 'defaulting to command: "bundle install \n rails db:migrate \n rake assets:precompile \n rails server"'
    bundle install

    if [ -e /usr/local/bundle/gems/adal-1.0.0/lib/adal/client_assertion_certificate.rb ]
      then
        # Workaround for issue https://github.com/AzureAD/azure-activedirectory-library-for-ruby/issues/44
        echo 'applying workaround for adal 1.0.0'
        sed -i "23 a require_relative \'request_parameters.rb\'" /usr/local/bundle/gems/adal-1.0.0/lib/adal/client_assertion_certificate.rb
    fi

    rake db:schema:load
    rake db:seed
    rake assets:precompile
    rails server
fi