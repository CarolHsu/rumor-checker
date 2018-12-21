class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

  def check
    reply_token = @event['replyToken']
    rumor       = @event['message']['text']

    ReplyWorker.new.perform(reply_token, rumor) if rumor

    head :ok
  end

  private

  def event
    @event = params['events'].first
  end
end
