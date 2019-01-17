require 'rails_helper'

RSpec.describe Intro, type: :lib do
  let(:token) { "00000000000000000000000000000000"  }
  let(:intro) do
    {
      type: "text",
      text: "早安您好～我是美玉姨!\n阿姨喜歡聽大家說的各種話並即時查詢假消息，\n我會提供多元看法幫助各位多想一下。\n至於大家曾經講過什麼，阿姨記性不好，過目即忘～\n很開心認識新朋友 <3\n"
    }
  end

  subject { Intro }

  it 'should #reply_message to line' do
    expect_any_instance_of(Line::Bot::Client).to receive(:reply_message).with(token, intro)
    Intro.talk(token)
  end
end

