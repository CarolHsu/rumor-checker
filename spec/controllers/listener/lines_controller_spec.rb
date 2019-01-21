require 'rails_helper'

RSpec.describe Listener::LinesController, type: :controller do
  describe 'POST #check' do
    let(:payload) do
      {
        "events": [
          { # This message is not forwarded message, should ignore
            "replyToken": "00000000000000000000000000000000",
            "type": "message",
            "timestamp": 1545406547368,
            "source": {
              "type": "user",
              "userId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
              "groupId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
            },
            "message": {
              "id": "100001",
              "type": "text",
              "text": "Hello, world",
            },
          },
          { # This message is a forwarded message, should perform
            "replyToken": "00000000000000000000000000000001",
            "type": "message",
            "timestamp": 1545406547368,
            "source": {
              "type": "user",
              "userId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
              "groupId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
            },
            "message": {
              "id": "100001",
              "type": "text",
              "text": "剛剛美國🇺🇸紐約皇后區發生商業街大爆炸事件。\n又一次911。美國的電視已經在報道。",
            },
          },
          {
            "replyToken": "ffffffffffffffffffffffffffffffff",
            "type": "message",
            "timestamp": 1545406547368,
            "source": {
              "type": "user",
              "userId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
              "groupId": "Udeadbeefdeadbeefdeadbeefdeadbeef",
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
      expect(ReplyWorker).not_to receive(:perform_async).with("00000000000000000000000000000000", "Hello, world")
      expect(ReplyWorker).to receive(:perform_async).with("00000000000000000000000000000001", "剛剛美國🇺🇸紐約皇后區發生商業街大爆炸事件。\n又一次911。美國的電視已經在報道。").once
      post :check, params: payload
    end

    it 'should introduce when join group / member join group' do
      expect(Intro).to receive(:talk).once
      post :check, params: payload
    end
  end
end
