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
            reply_sign_in_message(event)
          when :new
            reply_sign_up_message(event)
          end
        end
      end
    end
    
    "OK"
  end
  
  private
    def nonce(token)
      ActionController::HttpAuthentication::Digest.nonce(token)
    end
    
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
    
    def reply_sign_in_message(event)
      res = client.create_link_token(event["source"]["userId"])
      link_token = JSON.parse(res.body)["linkToken"]
      messages = [
        type: 'template',
        altText: '連携するためにアプリにログインしてください。',
        template: {
          type: 'buttons',
          text: 'シフト管理アプリにアプリにログインしてください。',
          defaultAction: {
            type: 'uri',
            label: "ログイン",
            uri: link_sign_in_url(linkToken: link_token)
          },
          actions: [
            {
              type: 'uri',
              label: "ログイン",
              uri: link_sign_up_url(linkToken: link_token)
            }
          ]
        }
      ]
      client.reply_message(event["replyToken"], messages)
    end
    
    def reply_sign_up_message(event)
      res = client.create_link_token(event["source"]["userId"])
      link_token = JSON.parse(res.body)["linkToken"]
      messages = [
        {
          type: 'text',
          text: 'ユーザー登録を行ってください。'
        },
        {
          type: 'text',
          text: new_user_registration_url(linkToken: link_token)
        }
      ]
      client.reply_message(event["replyToken"], messages)
    end
end
