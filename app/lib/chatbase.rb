class Chatbase
  HOST_URL = "https://chatbase-area120.appspot.com/api/message"

  SUPPORTED_ACTION = %w(intent_with_handling intent_without_handling send_bot_message click_link)

  def initialize(options)
    @user_id = options[:user_id]
    @message = options[:message]
    @group_id = options[:group_id]
    @article_url = options[:article_url]
  end

  def post(action)
    raise StandardError, "Not supported action: #{action}" unless SUPPORTED_ACTION.include? action

    action_body = send("#{action}_body")
    action_host = get_current_host(action)

    HTTParty.post(
      action_host,
      body: action_body.to_json,
      hearders: build_headers.to_json
    )
  end

  private

  def get_current_host(action)
    case action
    when 'click_link'
      "https://chatbase.com/api/click"
    else
      HOST_URL
    end
  end

  def intent_with_handling_body
    {
      "api_key" => ENV["chatbase"],
      "type" => "user",
      "user_id" => @user_id,
      "time_stamp" => epoch_time_now,
      "platform" => "Line",
      "message" => @message,
      "intent" => "rumor-search",
      "version" => "1.1",
      "session_id" => @group_id
    }
  end

  def intent_without_handling_body
    {
      "api_key" => ENV["chatbase"],
      "type" => "user",
      "user_id" => @user_id,
      "time_stamp" => epoch_time_now,
      "platform" => "Line",
      "message" => @message,
      "not_handled" => true,
      "version" => "1.1",
      "session_id" => @group_id
    } 
  end

  def send_bot_message_body
    {
      "api_key" => ENV["chatbase"],
      "type" => "agent",
      "user_id" => @user_id,
      "time_stamp" => epoch_time_now,
      "platform" => "Line",
      "message" => @message,
      "version" => "1.1",
      "session_id" => @group_id
    }
  end

  def click_link_body
    {
      "api_key" => ENV['chatbase'],
      "url" => @article_url,
      "platform" => "Line",
      "user_id" => @user_id,
      "version" => "1.1",
    }
  end

  def build_headers
    {
      'Content-Type': 'application/json'
    }
  end

  def epoch_time_now
    Time.zone.now.to_i * 1000
  end
end
