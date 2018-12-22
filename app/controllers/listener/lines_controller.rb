class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

  def check
    reply_token = @event['replyToken']
    rumor       = @event['message']['text']

    ReplyWorker.perform_async(reply_token, rumor) if rumor

    head :ok
  end

  private

  def event
    # TODO(Carol): TBC - not sure if it's always same events
    @event = params['events'].first
  end
end
