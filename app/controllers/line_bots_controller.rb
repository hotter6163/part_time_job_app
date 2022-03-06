class LineBotsController < ApplicationController
  include EnvironmentVariable unless Rails.env.production?
  
  skip_before_action :verify_authenticity_token
  before_action :validate_signature
  
  def callback
    "OK"
  end
  
  private
    def validate_signature
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        halt :bad_request
      end
    end
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = Rails.env.production? ? ENV["LINE_CHANNEL_SECRET"] : LINE_CHANNEL_SECRET
        config.channel_token = Rails.env.production? ? ENV["LINE_CHANNEL_TOKEN"] : LINE_CHANNEL_TOKEN
      }
    end
end
