class ReplyDecorator
  RUMOR_TYPES = {
    "RUMOR" => "這是謠言",
    "NOT_RUMOR" => "這是真的",
    "OPINIONATED" => "個人觀點",
  }

  def initialize(replies)
    @replies = JSON.parse(replies)["data"]["GetArticle"]["articleReplies"]
    @final_reply = []
  end

  def prettify
    @final_reply << conclusion
    @final_reply += gather_reasons

    {
      type: 'text',
      text: @final_reply.join("\n---------------\n"),
    }
  end

  private

  def conclusion
    types = @replies.map { |r| r['reply']['type'] }
    return "👵 #{RUMOR_TYPES[types.first]}。" if types.uniq.one?
    return "👵 部分是謠言。" if types.any? 'RUMOR'
    return "👵 包含個人觀點。" if types.any? 'OPINIONATED'
  end

  def gather_reasons
    @replies.map do |r|
      type = r['reply']['type']
      reason = r['reply']['text']
      reference = r['reply']['reference']

      reply = "#{RUMOR_TYPES[type]}理由🔎:\n #{reason}"
      reply += "\n 📖 #{reference} "if reference
      reply
    end
  end
end
