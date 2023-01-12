FROM ruby:3.0.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /rails_toolbox
WORKDIR /rails_toolbox
ADD Gemfile /rails_toolbox/Gemfile
ADD Gemfile.lock /rails_toolbox/Gemfile.lock
RUN bundle install
ADD . /rails_toolbox
