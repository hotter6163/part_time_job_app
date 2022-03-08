class LineBotsController < ApplicationController
  include Line::Client
  
  skip_before_action :verify_authenticity_token
  before_action :validate_signature
  
  def callback
    events = client.parse_events_from(@body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    
    "OK"
  end
  
  private
    def validate_signature
      @body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(@body, signature)
        halt :bad_request
      end
    end
end
