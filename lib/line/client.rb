module Line
  module Client
    include Line::EnvironmentVariable unless Rails.env.production?
    
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = Rails.env.production? ? ENV["LINE_CHANNEL_SECRET"] : LINE_CHANNEL_SECRET
        config.channel_token = Rails.env.production? ? ENV["LINE_CHANNEL_TOKEN"] : LINE_CHANNEL_TOKEN
      }
    end
  end
end
    