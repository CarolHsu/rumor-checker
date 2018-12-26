require 'rails_helper'

RSpec.describe Intro, type: :lib do
  let(:token) { "00000000000000000000000000000000"  }
  let(:intro) do
    <<~INTRO
    早安您好～我是美玉姨!
    我會聽大家說的各種話並即時查詢假消息，
    很開心認識新朋友 <3
    INTRO
  end

  subject { Intro }

  it 'should #reply_message to line' do
    expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).with(token, intro)
    Intro.talk(token)
  end
end

