require 'line/bot'

class Forward
  class << self
    def talk(token, message)
      initiate_client
      @client.reply_message(token, forwardToCofacts(message))
    end

    private

    def initiate_client
      @client = Line::Bot::Client.new do |config|
        config.channel_secret = ENV['line_channel_secret']
        config.channel_token = ENV['line_channel_token']
      end
    end

    def forwardToCofacts message
      [{
        type: 'text',
        text: '我也沒有看過這個訊息耶。'
      }, {
        type: 'flex',
        altText: '要不要傳給 Cofacts 真的假的機器人問問看呢？我平常也都是問它的唷！',
        contents: {
          type: 'bubble',
          body: {
            type: 'box',
            layout: 'vertical',
            contents: [
              {
                type: 'text',
                wrap: true,
                contents: [
                  {
                    type: 'span',
                    text: '要不要傳給'
                  },
                  {
                    type: 'span',
                    text: ' Cofacts 真的假的 ',
                    color: '#ffb600',
                  },
                  {
                    type: 'span',
                    text: '機器人問問看呢？<br>它有最大的資料庫、也會搜集新謠言，我平常都是問它的唷！'
                  }
                ]
              },
              {
                type: 'button',
                action: {
                  type: 'uri',
                  label: '傳給 Cofacts 真的假的',
                  uri: 'https://line.me/R/oaMessage/@cofacts/?' +  URI.encode(message[0..100])
                },
                style: 'primary',
                color: '#ffb600',
                offsetTop: 'lg',
              }
            ]
          }
        }
      }]
    end
  end
end

