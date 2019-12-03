class Listener::LinesController < ApplicationController
  before_action :valid_signature, only: [:check]

  def check
    head :ok
  end

  private

  def valid_signature
    params[:app_id] == ENV['telegram_app_id']
  end
end
