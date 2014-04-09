# ENV["RAILS_ENV"] ||= "test"
# require File.expand_path('../../config/environment', __FILE__)
# require 'rails/test_help'

# class ActiveSupport::TestCase
#   ActiveRecord::Migration.check_pending!

#   # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
#   #
#   # Note: You'll currently still have to declare fixtures explicitly in integration tests
#   # -- they do not yet inherit this setting
#   fixtures :all

#   # Add more helper methods to be used by all tests here...
# end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.mock_with :mocha
  config.include AuthenticationHelper
end