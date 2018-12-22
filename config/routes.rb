Rails.application.routes.draw do
  namespace :listener do
    resource :line, only: [] do
      member do
        post :check
      end
    end
  end
end
