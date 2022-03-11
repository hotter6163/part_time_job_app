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
            text: "test\ntest"
          }
          client.reply_message(event['replyToken'], message)
        end
      when Line::Bot::Event::Postback
        data = parse(event["postback"]["data"])
        case data[:action]
        when :link
          case data[:user]
          when :exist
            reply_log_in_message(event)
          when :new
            reply_sign_up_message(event)
          end
        end
      when Line::Bot::Event::AccountLink
        account_link(event)
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
    
    def reply_log_in_message(event)
      res = client.create_link_token(event["source"]["userId"])
      link_token = JSON.parse(res.body)["linkToken"]
      messages = [
        {
          type: 'template',
          altText: '連携するためにアプリにログインしてください。',
          template: {
            type: 'buttons',
            text: 'シフト管理アプリにログインしてください。',
            defaultAction: {
              type: 'uri',
              label: "ログイン",
              uri: link_log_in_url(link_token: link_token)
            },
            actions: [
              {
                type: 'uri',
                label: "ログイン",
                uri: link_log_in_url(link_token: link_token)
              }
            ]
          }
        }
      ]
      client.reply_message(event["replyToken"], messages)
    end
    
    def reply_sign_up_message(event)
      res = client.create_link_token(event["source"]["userId"])
      link_token = JSON.parse(res.body)["linkToken"]
      messages = [
        {
          type: 'template',
          altText: '連携するためのユーザーを登録してください。',
          template: {
            type: 'buttons',
            text: "シフト管理アプリに新規登録してください。",
            defaultAction: {
              type: 'uri',
              label: "新規登録",
              uri: link_sign_up_url(link_token: link_token)
            },
            actions: [
              {
                type: 'uri',
                label: "新規登録",
                uri: link_sign_up_url(link_token: link_token)
              }
            ]
          }
        }
      ]
      client.reply_message(event["replyToken"], messages)
    end
    
    def account_link(event)
      if event["link"]["result"] == "ok"
        if line_link_nonce = LineLinkNonce.find_by(nonce: event["link"]["nonce"])
          line_link = LineLink.create(user_id: line_link_nonce.user_id, line_id: event["source"]["userId"])
          user = line_link.user
          Line::RichMenu.create_rich_menu_for_linked_user(user, line_link.line_id)
          reply_success_message(event["replyToken"])
        end
      end
    end
    
    def reply_success_message(reply_token)
      messages = [
        {
          type: "text",
          text: "アカウント連携が完了しました。\nアカウント連携を解除する場合は、下のメニューの「連携を解除する」から行ってください。"
        }
      ]
      
      client.reply_message(reply_token, messages)
    end
end
