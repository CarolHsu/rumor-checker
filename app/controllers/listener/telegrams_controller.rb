class Listener::TelegramsController < ApplicationController
  before_action :get_message, only: [:check]
  before_action :get_params, only: [:check]

  def check
    if private_chat? and about_coronavirus?
      answer_query
    else
      check_rumor !private_chat?
    end

    head :ok
  end

  private

  def set_platform
    @platform = 'telegram'
  end

  def get_message
    @message = params[:message]
  end

  def get_params
    @reply_token = @message[:chat][:id]
    @chat_type   = @message[:chat][:type]
    @rumor       = @message[:text]
  end

  def private_chat?
    @chat_type == 'private'
  end
end
