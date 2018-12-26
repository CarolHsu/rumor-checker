require 'line/bot'

class ReplyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(token, rumor)
    @token = token
    replies = Rumors::Api::Client.search(rumor).try(:body)
    return unless replies

    reply = ReplyDecorator.new(replies).prettify

    talk(reply)
  end

  private

  def talk(reply)
    initiate_client
    @client.reply_message(@token, reply)
  end

  def initiate_client
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token = ENV['line_channel_token']
    end
  end
end
