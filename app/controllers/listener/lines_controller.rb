class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

  def check
    @events.each do |event|
      reply_token = event['replyToken']
      rumor       = event['message']['text']

      ReplyWorker.perform_async(reply_token, rumor) if rumor
    end

    head :ok
  end

  private

  def event
    @uniq_event_tokens = params['events'].map { |e| e['replyToken'] }.uniq
    @events = params['events'].select { |e| @uniq_event_tokens.include?(e['replyToken']) }
  end
end
