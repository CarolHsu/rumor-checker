class ApplicationController < ActionController::API
  before_action :set_platform

  def set_platform
    raise NotImplementedError
  end

  def forwardable?(rumor)
    return false unless rumor
    rumor.length > 20
  end

  def get_current_user
    @user = User.send("from_#{@platform}").find_by(external_id: @user_id)
  end

  def check_intention
    if MENU[:keywords].include?(@rumor&.downcase)
      # to start the menu
      @user ||= User.new(external_id: @user_id)
      @user.send("from_#{@platform}") unless @user.platform
      @user.menu_level = 1 # ready to query
      @user.save
      @rumor = "0" # go to menu
    elsif @user && @user.menu_level > 0 && @rumor&.downcase == 'ok'
      # to end the menu
      @user.menu_level = 0 # stop querying
      @user.save
    end
  end

  def about_coronavirus?
    get_current_user
    check_intention
    return unless @user
    @user.menu_level > 0
  end

  def check_rumor is_group_chat
    ReplyWorker.perform_async(@reply_token, @rumor, @platform, is_group_chat) if forwardable?(@rumor)
  end

  def answer_query
    CoronavirusReplyWorker.perform_async(@reply_token, @rumor, @platform)
  end
end
