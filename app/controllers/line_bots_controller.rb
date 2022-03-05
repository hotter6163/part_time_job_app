require 'sinatra'   # gem 'sinatra'
require 'line/bot'  # gem 'line-bot-api'

class LineBotsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_signature
  
  def callback
    "OK"
  end
  
  private
    def validate_signature
      CHANNEL_SECRET = ENV["LINE_CHANNEL_SECRET"]
      http_request_body = request.raw_post # Request body string
      hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
      signature = Base64.strict_encode64(hash)
      x_line_signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless signature == x_line_signature
        raise RuntimeError
      end
      
      # body = request.body.read
      # signature = request.env['HTTP_X_LINE_SIGNATURE']
      # unless client.validate_signature(body, signature)
      #   error 400 do 'Bad Request' end
      # end
    end
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end
