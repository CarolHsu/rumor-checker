require 'line/bot'

LineBotClient = Line::Bot::Client.new do |config|
  config.channel_secret = ENV['line_channel_secret']
  config.channel_token  = ENV['line_channel_token']
end
