class Listener::LinesController < ApplicationController
  before_action :events, only: [:check]

  def check
    @events.each do |event|
      reply_token = event['replyToken']
      rumor       = event['message']['text']
      next unless rumor

      ReplyWorker.perform_async(reply_token, rumor)
    end

    head :ok
  end

  private

  def events
    @events = params['events']
  end
end
