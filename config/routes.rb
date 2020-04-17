Rails.application.routes.draw do
  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["sidekiq_username"] && password == ENV["sidekiq_password"]
  end
  mount Sidekiq::Web, at: "/sidekiq"

  namespace :listener do
    resource :line, only: [] do
      member do
        post :check
      end
    end

    resource :telegram, only: [] do
      member do
        post '/:app_id/check', "telegrams#check"
      end
    end
  end
end
