require 'rails_helper'

RSpec.describe Listener::LinesController, type: :controller do
  describe 'POST #check' do
    it 'should return status ok' do
      post :check
      expect(response).to have_http_status(:ok)
    end
  end
end
