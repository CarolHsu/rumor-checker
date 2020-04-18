require 'line/bot'

class CoronavirusReplyWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(token, rumor, platform='line')
    @token = token
    @rumor = rumor
    @platform = platform

    answer_for_nonsense_query
    answer_for_query unless @answer
    answer_for_out_of_service_query unless @answer

    talk(@answer)
  end

  private

  def answer_for_nonsense_query
    @rumor = begin
               Integer(@rumor)
             rescue
               nil
             end

    return if @rumor
    @answer = '抱歉，這超出我的回答範圍囉。'
  end

  def answer_for_out_of_service_query
    @answer = '抱歉，這超出我的回答範圍囉。'
  end

  def answer_for_query
    @answer = MENU[@rumor]
    @answer = eval(@answer) if @rumor == 1 # http request for latest data
  end

  def talk(reply)
    case @platform
    when 'line'
      client = initiate_client
      client.reply_message(@token, reply)
    when 'telegram'
      HTTParty.post(
        "https://api.telegram.org/bot#{ENV['telegram_app_token']}/sendMessage",
        headers: { "Content-Type": "application/json"},
        body: {
          chat_id: @token,
          text: reply
        }
      )
    end
  end
end
