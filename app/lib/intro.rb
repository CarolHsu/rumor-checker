class Intro
  class << self
    def talk(token)
      LineBotClient.reply_message(token, introduction)
    end

    private

    def introduction
      text = <<~INTRO
      早安您好～我是美玉姨!
      阿姨喜歡聽大家說的各種話並即時查詢假消息，
      我會提供多元看法幫助各位多想一下。
      至於大家曾經講過什麼，阿姨記性不好，過目即忘～
      很開心認識新朋友 <3
      INTRO

      {
        type: 'text',
        text: text
      }
    end
  end
end

