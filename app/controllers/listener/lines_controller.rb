class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

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

  def event
    @uniq_event_tokens = params['events'].map { |e| e['replyToken'] }.uniq
    @events = params['events'].select { |e| @uniq_event_tokens.include?(e['replyToken']) }
  end

  def react(event)
    intro_events = %w(join)
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
    information = {
      'token' => event['replyToken'],
      'user_id' => event['source']['userId'],
      'group_id' => event['source']['groupId'] || event['source']['roomId'],
    }
    rumor = event['message']['text']

    ReplyWorker.perform_async(information, rumor) if forwardable?(rumor)
  end

  def introduce(event)
    reply_token = event['replyToken']
    Intro.talk(reply_token)
  end
end
