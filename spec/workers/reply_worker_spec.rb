require 'rails_helper'

RSpec.describe ReplyWorker do
  let(:token) { "00000000000000000000000000000000" }
  let(:rumor) { "行政院最新公告～元旦放七天嘍！收到這訊息。千萬別點閱，因為有病毒，已有朋友中獎了，請大家告訴大家!如果有收到，元旦放七天，的那個是釣魚網站，別點。" }

  subject { ReplyWorker }

  it 'should #reply_message to line' do
    Sidekiq::Testing.inline! do
      expect_any_instance_of(Line::Bot::Client).to receive(:reply_message)
      ReplyWorker.new.perform(token, rumor)
    end
  end
end
