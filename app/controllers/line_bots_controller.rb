class LineBotsController < ApplicationController
  include Line::Client
  include JSON
  
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
      when Line::Bot::Event::Postback
        data = parse(event["postback"]["data"])
        case data[:action]
        when :link
          case data[:user]
          when :exist
            res = client.create_link_token(event["source"]["userId"])
            link_token = JSON.parse(res.body)["linkToken"]
            messages = [
              {
                type: 'text',
                text: '以下のリンクからアプリにログインしてください。'
              },
              {
                type: 'text',
                text: new_user_session_url(linkToken: link_token)
              }
            ]
            client.reply_message(event["replyToken"], messages)
          when :new
            res = client.create_link_token(event["source"]["userId"])
            link_token = JSON.parse(res.body)["linkToken"]
            messages = [
              {
                type: 'text',
                text: '以下のリンクからユーザー登録を行ってください。'
              },
              {
                type: 'text',
                text: new_user_registration_url(linkToken: link_token)
              }
            ]
            client.reply_message(event["replyToken"], messages)
          end
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
    
    def parse(str)
      result = {}
      str.split("&").each do |item|
        key, value = item.split("=")
        result[key.to_sym] = value.to_sym
      end
      result
    end
end
