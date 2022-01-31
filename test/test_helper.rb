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
  
  def new_user_registration_path(hash={})
    result = "/users/sign_up"
    hash.each_with_index { |row, index| result += ( index == 0 ? "?#{row[0]}=#{row[1]}" : "=#{row[0]}=#{row[1]}") }
    result
  end
  
  def new_relationship_path(hash={})
    result = "/relationships/new"
    hash.each_with_index { |row, index| result += ( index == 0 ? "?#{row[0]}=#{row[1]}" : "=#{row[0]}=#{row[1]}") }
    result
  end
end

class ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include Devise::Test::IntegrationHelpers
  MAX_NUM = 100000
  
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
  
  def forms_num(branch)
    case branch.subtype
    when Weekly
      case branch.subtype.num_of_weeks
      when 1 then { default: 4, max: 7 }
      when 2 then { default: 7, max: 14 }
      end
    when Monthly
      case branch.subtype.period_num
      when 1 then { default: 15, max: 31 }
      when 2 then { default: 8, max: 16 }
      end
    end
  end
end
