require 'rails_helper'

RSpec.describe Listener::LinesController, type: :controller do
  describe 'POST #check' do
    let(:payload) do
      {
        "events": [
          {
            "replyToken": "00000000000000000000000000000000",
            "type": "message",
            "timestamp": 1545406547368,
            "source": {
              "type": "user",
              "userId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
            },
            "message": {
              "id": "100001",
              "type": "text",
              "text": "Hello, world",
            },
          },
          {
            "replyToken": "ffffffffffffffffffffffffffffffff",
            "type": "message",
            "timestamp": 1545406547368,
            "source": {
              "type": "user",
              "userId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
            },
            "message": {
              "id": "100002",
              "type": "sticker",
              "packageId": "1",
              "stickerId": "1",
            },
          },
          {
            "replyToken": "0f3779fba3b349968c5d07db31eabf65",
            "type": "memberJoined",
          },
          {
            "replyToken": "nHuyWiB7yP5Zw52FIkcQobQuGDXCTA",
            "type": "join",
          },
        ],
      }
    end

    it 'should return status ok' do
      post :check, params: payload
      expect(response).to have_http_status(:ok)
    end

    it 'should assign ReplyWorker' do
      expect(ReplyWorker).to receive(:perform_async).with("00000000000000000000000000000000", "Hello, world").once
      post :check, params: payload
    end

    it 'should introduce when join group / member join group' do
      expect(Intro).to receive(:talk).twice
      post :check, params: payload
    end
  end
end
