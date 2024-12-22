#!/usr/bin/env rackup -p3000
require 'rack'
require ::File.expand_path('../vendor/plugins/cdn_asset_path/lib/rack/asset_path', __FILE__)
require ::File.expand_path('../config/environment', __FILE__)

use Rails::Rack::LogTailer
use Rack::AssetPath
use Rails::Rack::Static
run ActionController::Dispatcher.new
