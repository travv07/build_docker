FROM ruby:3.0.4
ENV APP_ROOT /rails_toolbox
RUN apt-get update -qq \
    && apt-get install -y libmariadb3 curl  \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && apt-get -s autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && gem update bundler \
    && mkdir $APP_ROOT
WORKDIR $APP_ROOT

RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y build-essential \
                          yarn
COPY Gemfile Gemfile.lock $APP_ROOT/

RUN bundle install

COPY Rakefile postcss.config.js package.json yarn.lock $APP_ROOT/
COPY bin/ $APP_ROOT/bin/
COPY config/ $APP_ROOT/config/
COPY app/assets/ $APP_ROOT/app/assets/
COPY app/javascript/ $APP_ROOT/app/javascript/
COPY .browserslistrc $APP_ROOT/.browserslistrc
COPY babel.config.js $APP_ROOT/babel.config.js
RUN : > config/routes.rb \
    && bundle exec rails yarn:install webpacker:compile assets:precompile

ADD . /$APP_ROOT
