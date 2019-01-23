require 'line/bot'

class ReplyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(information, rumor)
    @information = information
    @rumor = rumor

    setup!
    work!
  end

  private

  def setup!
    set_token
    set_chatbase
  end

  def work!
    article = Rumors::Api::Client.search(@rumor)

    catchup_analytics(article)
    return inless article

    decorate!(article)
    set_chatbase_for_bot

    talk!
  end

  def decorate!(article)
    reply_decorator = ReplyDecorator.new(article["articleReplies"], article["id"])
    @reply = reply_decorator.prettify
    @article_url = reply_decorator.article_url
  end

  def talk!
    initiate_client
    @client.reply_message(@token, @reply)

    bot_behaviour_analytics
  end

  def initiate_client
    @client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token = ENV['line_channel_token']
    end
  end

  def set_token
    @token = @information['token']
  end

  def set_chatbase
    options = {
      user_id: @information['user_id'],
      group_id: @information['group_id'],
      message: @rumor,
    }
    @chatbase = Chatbase.new(options)
  end

  def set_chatbase_for_bot
    options = {
      user_id: @information['user_id'],
      group_id: @information['group_id'],
      message: @reply,
      url: @article_url,
    }
    @bot_chatbase = Chatbase.new(options)
  end

  def catchup_analytics(article)
    if article.present?
      @chatbase.post('intent_with_handling')
    else
      @chatbase.post('intent_without_handling')
    end
  end

  def bot_behaviour_analytics
    @bot_chatbase.post('send_bot_message')
    @bot_chatbase.post('click_link')
  end
end
