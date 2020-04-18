class Listener::LinesController < ApplicationController
  before_action :event, only: [:check]

  def check
    @events.each do |event|
      react(event)
    end

    head :ok
  end

  private

  def event
    @uniq_event_tokens = params['events'].map { |e| e['replyToken'] }.uniq
    @events = params['events'].select { |e| @uniq_event_tokens.include?(e['replyToken']) }
  end

  def react(event)
    get_params(event)

    intro_events = %w(join)
    case @event_type
    when 'message'
      if group_chat?(event)
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

  def check_rumor
    ReplyWorker.perform_async(@reply_token, @rumor) if forwardable?(@rumor)
  end

  def answer_query
    CoronavirusReplyWorker.perform_async(@reply_token, @rumor)
  end

  def introduce(event)
    reply_token = event['replyToken']
    Intro.talk(reply_token)
  end

  def get_params
    @event_type  = event['type']
    @reply_token = event['replyToken']
    @rumor       = event['message']['text']
    @user_id     = event['source']['userId']
    @room_id     = event['source']['roomId']
  end

  def group_chat?
    @room_id.present?
  end

  def get_current_user
    @user = User.from_line.find_by(external_id: @user_id)
  end

  def check_intention
    if keywords.include(@rumor.downcase)
      # to start the menu
      @user ||= User.new(external_id: @user_id, platform: 'line')
      @user.menu_level = 1
      @user.save
      @rumor = "0" # go to menu
    elsif @user.menu_level > 0 && @rumor.downcase == 'ok'
      # to end the menu
      @user.menu_level = 0
      @user.save
    end
  end

  def about_coronavirus?
    get_current_user
    check_intention
    return unless @user
    @user.menu_level > 0
  end
end
