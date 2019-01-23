class ReplyDecorator
  WEBSITE = "https://cofacts.g0v.tw/article/"

  RUMOR_TYPES = {
    "RUMOR" => "這是謠言",
    "NOT_RUMOR" => "這是真的",
    "NOT_ARTICLE" => "非查證範圍",
    "OPINIONATED" => "個人觀點",
  }

  PREFIX_EMOJIS = {
    conclusion: "👵",
    reply: "🔎",
    reference: "📖"
  }

  def initialize(replies, article_id)
    @replies = replies
    @article_id = article_id
    @final_reply = []
  end

  def prettify
    @final_reply << conclusion
    @final_reply += format_replies if @replies.any?
    @final_reply << footnote
    {
      type: 'text',
      text: @final_reply.join("\n--------------\n")
    }
  end

  def article_url
   "#{WEBSITE}#{@article_id}"
  end

  private

  def conclusion
    return "啊，還沒有人查證喔。成為全球第一個回應的人？" unless @replies.present?

    types = @replies.map { |r| r['reply']['type'] }
    h = Hash.new(0)
    types.each { |v| h[v] +=1 }
    grouped_types = h.sort_by {|_key, value| value}.to_h
    
    summary = grouped_types.map do |type, count|
      "有 #{count} 則查證表示#{RUMOR_TYPES[type]}"
    end.join(', ')

    return "#{PREFIX_EMOJIS[:conclusion]} #{summary}"
  end

  def format_replies
    freplies =  @replies.map do |r|
      type = r['reply']['type']
      reason = r['reply']['text']
      reference = r['reply']['reference']

      reply = case type
              when "NOT_ARTICLE" then "一則回應表示這#{RUMOR_TYPES["NOT_ARTICLE"]} "
              when "OPINIONATED" then "一則回應表示這是#{RUMOR_TYPES["OPINIONATED"]} "
              else
                "一則關於#{RUMOR_TYPES[type]}的查證 "
              end
      reply += PREFIX_EMOJIS[:reply]
      reply += "\n#{reason}\n"
      reply += "#{PREFIX_EMOJIS[:reference]} #{reference}" if reference.present?
      reply
    end
    freplies
  end

  def footnote
    "你也查到了其他的論點嗎？歡迎回應在 #{WEBSITE}#{@article_id} !"
  end
end
