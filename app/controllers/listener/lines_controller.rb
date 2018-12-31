class Listener::LinesController < ApplicationController
  before_action :set_event, only: [:check]

  def check
    @events.each do |event|
      react(event)
    end

    head :ok
  end

  private

  def forwardable?(rumor)
    return false unless rumor
    rumor.length > 20
  end

  def set_events
    @events = params[:events].uniq { |event| event['replyToken'] }
  end

  def react(event)
    intro_events = %w(join memberJoined)
    case event['type']
    when 'message'
      check_rumor(event)
    when *intro_events
      introduce(event)
    else
      return
    end
  end

  def check_rumor(event)
    reply_token = event['replyToken']
    rumor       = event['message']['text']

    ReplyWorker.perform_async(reply_token, rumor) if forwardable?(rumor)
  end

  def introduce(event)
    reply_token = event['replyToken']
    Intro.talk(reply_token)
  end
end
