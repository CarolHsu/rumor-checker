class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

  def check
    @events.each do |event|
      react(event)
    end

    head :ok
  end

  private

  def set_platform
    @platform = 'line'
  end

  def event
    @uniq_event_tokens = params['events'].map { |e| e['replyToken'] }.uniq
    @events = params['events'].select { |e| @uniq_event_tokens.include?(e['replyToken']) }
  end

  def react(event)
    get_params(event)

    intro_events = %w(join)
    case @event_type
    when 'message'
      if group_chat?
        check_rumor
      else # 1-on-1 chat
        if about_coronavirus?
          answer_query
        else
          check_rumor
        end
      end
    when *intro_events
      introduce(event)
    else
      return
    end
  end

  def introduce(event)
    reply_token = event['replyToken']
    Intro.talk(reply_token)
  end

  def get_params(event)
    @event_type  = event['type']
    @reply_token = event['replyToken']
    @rumor       = event['message']['text']
    @user_id     = event['source']['userId']
    @room_id     = event['source']['roomId']
  end

  def group_chat?
    @room_id.present?
  end
end
