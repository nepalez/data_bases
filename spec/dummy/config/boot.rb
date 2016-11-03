ENV["RAILS_ENV"] ||= "test"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../../Gemfile", __FILE__)

require "bundler/setup"
require "rails/all"
Bundler.require(:default, Rails.env)

require_relative "application"
Dummy::Application.initialize!
