require 'line/bot'

class ReplyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(information, rumor)
    @token = information['token']
    @user_id = information['user_id']
    @group_id = information['group_id']

    Chatbase.new(@user_id, rumor, @group_id).post('intent_with_handling')
    article = Rumors::Api::Client.search(rumor)
    return unless article

    reply = ReplyDecorator.new(article["articleReplies"], article["id"]).prettify

    Chatbase.new(@user_id, reply, @group_id).post('send_bot_message')
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
