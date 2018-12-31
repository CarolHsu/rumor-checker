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
    LineBotClient.reply_message(@token, reply)
  end
end
