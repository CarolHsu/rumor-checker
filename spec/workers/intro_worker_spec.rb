require 'rails_helper'

RSpec.describe ReplyWorker do
  let(:token) { "00000000000000000000000000000000"  }
  let(:intro) do
    <<-INTRO
    早安您好～我是美玉姨!
    我會聽大家說的各種話並即時查詢假消息，
    很開心認識新朋友 <3
    INTRO
  end

  subject { IntroWorker  }

  it 'should #reply_message to line' do
    Sidekiq::Testing.inline! do
      expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).with(token, intro)
      IntroWorker.new.perform(token)
    end
  end
end

