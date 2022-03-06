class LineBotsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 401
    end
    
    "OK"
  end
  
  private
    def validate_signature
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
      end
    end
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end
