$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

# Loads Dummy app
require_relative "dummy/config/boot"
require "rspec-rails"
require "rspec/its"
require "pry"

# Loads support files
Dir["spec/support/*.rb"].each(&method(:load))

RSpec.configure do |config|
  require "rake"
  config.include DummyHelpers, type: :rake
  config.before :each, type: :rake do
    Rake::Task.clear
    Rails.application.load_tasks
    Rake::Task.tasks.map(&:reenable)
  end
end
