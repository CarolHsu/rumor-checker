require 'rails_helper'

RSpec.describe ReplyDecorator, type: :lib do
  let!(:article) do
    {
      "id" => "5394036018554-rumor",
      "text" => "行政院最新公告～元旦放七天嘍！收到這訊息。千萬別點閱，因為有病毒，已有朋友中獎了，請大家告訴大家!如果有收到，元旦放七天，的那個是釣魚網站，別點",
      "hyperlinks" => [],
      "articleReplies" =>
      [
        {
          "reply" => {
            "id" => "5361365129457-answer",
            "text" => "人事行政總處已確認，明年的元旦假期只有4天假期，顯然說法有明顯出入，且該連結的安全性受到質疑。警政署165專線表示，初步判定該點選連結不會竊取個資，而連結網站惡作劇使用JavaScript產生彈跳視窗，民眾只要關閉就不會出現，並非惡意程式。",
            "type" => "RUMOR",
            "reference" => "http://www.appledaily.com.tw/realtimenews/article/new/20141209/520844/"
          }
        },
        {
          "reply" => {
            "id" => "5394036018554-answer",
            "text" => "其實早在兩年前，這樣的訊息就已經開始流傳，165反詐騙專線也證實這是惡作劇網站，初判不會竊取用戶個資。",
            "type" => "RUMOR",
            "reference" => "http://www.setn.com/News.aspx?NewsID=187698"
          }
        },
        {
          "reply" => {
            "id" => "AV8UubqFyCdS-nWhuhVz",
            "text" => "人事行政總處已確認，明年的元旦假期只有4天假期，顯然說法有明顯出入，且該連結的安全性受到質疑。早在兩年前，這樣的訊息就已經開始流傳，165 反詐騙專線也證實這是惡作劇網站，不會竊取用戶個資。警政署165專線表示，而連結網站惡作劇使用JavaScript產生彈跳視窗，民眾只要關閉就不會出現，並非惡意程式。",
            "type" => "RUMOR",
            "reference" => "http://www.appledaily.com.tw/realtimenews/article/new/20141209/520844/\nLINE釣魚訊息瘋傳　元旦放7天係假\n\nhttp://www.setn.com/News.aspx?NewsID=187698\n元旦放7天?"
          }
        }
      ]
    }
  end

  subject { ReplyDecorator.new(article["articleReplies"], article["id"]) }

  it 'should return expected conclusion' do
    expected_reply = subject.prettify
    expect(expected_reply.keys).to match_array %i(type text)
  end
end
