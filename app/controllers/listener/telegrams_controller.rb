class Listener::TelegramsController < ApplicationController
  before_action :get_message, only: [:check]

  def check
    reply_token = @message[:chat][:id]
    rumor = @message[:text]

    return unless forwardable?(rumor)

    ReplyWorker.perform_async(reply_token, rumor, 'telegram')

    head :ok
  end

  private

  def get_message
    @message = params[:message]
  end
end
