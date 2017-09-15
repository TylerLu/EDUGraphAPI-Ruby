FROM ruby:2.3.0
run apt-get update && apt-get install -y vim

run mkdir /msgraph
workdir /msgraph
env RAILS_ENV production
env SECRET_KEY_BASE nihao
add Gemfile /msgraph
add Gemfile.lock /msgraph
run gem install bundler && bundle install
add . /msgraph
add config/database.yml.docker /msgraph/config/database.yml
run bundle exec rake assets:precompile