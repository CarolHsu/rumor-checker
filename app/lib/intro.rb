require 'line/bot'

class Intro
  class << self
    def talk(token)
      initiate_client
      @client.reply_message(token, introduction)
    end

    private

    def initiate_client
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = ENV['line_channel_secret']
        config.channel_token = ENV['line_channel_token']
      end
    end

    def introduction
      <<~INTRO
      早安您好～我是美玉姨!
      我會聽大家說的各種話並即時查詢假消息，
      很開心認識新朋友 <3
      INTRO
    end
  end
end

