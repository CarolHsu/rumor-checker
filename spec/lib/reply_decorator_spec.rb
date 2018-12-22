require 'rails_helper'

RSpec.describe ReplyDecorator, type: :lib do
  let!(:replies) do
    {
      "data": {
        "GetArticle": {
          "id": "AV1OgBQzyCdS-nWhucc-",
          "text": "驚！99％的人不知道，吃這個水果，才能預防「中風死亡」！轉載一次救人一命！！\nhttp://ezp9.com/p50099.asp",
          "articleReplies": [
            {
              "reply": {
                "id": "AV19X3c9yCdS-nWhudEH",
                "text": "香蕉確實含有鉀，適量攝取對於高血壓、預防心血管疾病確實有幫助。不過醫師強調，過量攝取無益處，要真正治本，還是要遵照醫師用藥指示，調整生活作息與改變飲食習慣，才是正確之道。",
                "type": "RUMOR",
                "reference": "https://www.nownews.com/news/20120801/163961\n網路追追追／吃香蕉好處多　抗高血壓防中風？",
              },
            },
          ],
        },
      },
    }.to_json
  end

  let!(:expected_reply) do
    "這是謠言。\n這是謠言: 香蕉確實含有鉀，適量攝取對於高血壓、預防心血管疾病確實有幫助。不過醫師強調，過量攝取無益處，要真正治本，還是要遵照醫師用藥指示，調整生活作息與改變飲食習慣，才是正確之道。"
  end

  subject { ReplyDecorator.new(replies) }

  it 'should return expected conclusion' do
    expect(subject.prettify).to eq(expected_reply)
  end
end
