ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # include Devise::TestHelpers
  
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # ログインしているかの確認用
  # headerの中のログアウトのURLが存在するかで確認
  def is_logged_in?(body)
    body.include?(destroy_user_session_path)
  end
end

class ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  MAX_NUM = 100000
  
  def sign_in(user, password: 'password')
    post user_session_path, params: { user: { email: user.email,
                                              password: password } }
  end
  
  def invalid_id
    relationship_ids = Relationship.all.map(&:id)
    result = 0
    (0..MAX_NUM).reverse_each do |i|
      result = i
      if !relationship_ids.include?(result)
        break
      end
    end
    result
  end
    
end
