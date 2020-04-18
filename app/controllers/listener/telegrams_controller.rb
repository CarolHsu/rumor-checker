class Listener::TelegramsController < ApplicationController
  before_action :get_message, only: [:check]
  before_action :get_params, only: [:check]

  def check
    check_rumor

    head :ok
  end

  private

  def check_rumor
    return unless forwardable?(@rumor)
    ReplyWorker.perform_async(@reply_token, @rumor, 'telegram')
  end

  def get_message
    @message = params[:message]
  end

  def get_params
    @reply_token = @message[:chat][:id]
    @chat_type   = @message[:chat][:type]
    @rumor       = @message[:text]
  end
end
