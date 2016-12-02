require 'capybara'
require 'capybara/rspec'
# require 'capybara/rails'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/autorun'
require "rails/all"

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
end

Capybara.configure do |config|
  config.current_driver = :selenium
  config.run_server = false
end

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :chrome
Capybara.default_driver = :selenium