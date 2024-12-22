source "https://rubygems.org"

gem 'ruby3-backward-compatibility'

git 'https://github.com/makandra/rails.git', :branch => '2-3-lts' do
  gem 'rails', '~>2.3.18'
  gem 'actionmailer',     :require => false
  gem 'actionpack',       :require => false
  gem 'activerecord',     :require => false
  gem 'activeresource',   :require => false
  gem 'activesupport',    :require => false
  gem 'railties',         :require => false
  gem 'railslts-version', :require => false
  gem 'rack',             :require => false
end

gem 'racc'
gem 'webrick'
gem 'rexml'

gem 'whenever', :require => false

group :production do
  gem 'rpm_contrib'
  gem 'newrelic-redis'
  gem 'newrelic_rpm'
  gem 'airbrake', :require => 'airbrake/rails'
  # used in prod, we don't need that now gem 'unicorn', :require => false
end

# databases

gem 'mysql2', '0.5.6'

gem 'memcache-client', :require => 'memcache'

gem 'hiredis', '~> 0.6.3'

gem 'redis', '~> 2.2.0', :require => ["redis/connection/hiredis", "redis"]


# extra

gem 'mime-types'
gem 'rake', '~>13'
gem 'rdoc'
#gem 'system_timer'
gem 'will_paginate', '~> 2.3.16'
gem 'coderay'
gem 'ruby-openid', :require => 'openid'
gem 'hpricot'
gem 'russian'

gem 'json', '~> 1.8'


# search

gem 'thinking-sphinx', :require => 'thinking_sphinx'
gem 'ts-datetime-delta', '>= 1.0.0', :require => 'thinking_sphinx/deltas/datetime_delta'

gem 'savon', '0.7.9', :require => false


# image assets

gem 'mini_magick'
gem 'paperclip', '= 2.3.9'
gem 'paperclip-meta'


# templates

# gem 'therubyracer', :require => false
gem 'sass', :require => false
gem 'haml'
gem 'compass', :require => false
gem 'uglifier', :require => false

gem 'resque', '1.19.0'
gem 'resque-lock'

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'capistrano_colors'
end

gem 'digest'
