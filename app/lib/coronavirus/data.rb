class Coronavirus::Data
  KEYWORDS = {
    "Global": "全球",
    "NewConfirmed": "最新確診人數",
    "TotalConfirmed": "總確診人數",
    "NewDeaths": "最新死亡人數",
    "TotalDeaths": "總死亡人數",
    "NewRecovered": "最新治癒人數",
    "TotalRecovered": "總治癒人數"
  }

  def initalize(timestamp)
    # renew by every hour
    @timestamp = @timestamp
    @data = Rails.cache.read(timestamp)

    if @data.nil?
      @data = get_summary
      Rails.cache.write(timestamp, @data)
    end
  end

  def process
    parsed_data = JSON.parse(@data)
    list = get_list(parsed_data)
    humanize_data(list)
  end

  private

  def get_summary
    HTTParty.get('https://api.covid19api.com/summary')
  end

  def humanize_data(list)
    list.map do |row|
      content = "#{row["Country"]}"
      row.each_pair do |key, value|
        next unless KEYWORDS[key]
        content += "\n - #{KEYWORDS[key]}: #{value}"
      end
    end

    content
  end

  def get_list(data)
    # Globally
    # TW
    # TOP 10 countries (by total confirmed)
    list = []

    global = data["Global"]
    global["Country"] = KEYWORDS["Global"]

    taiwan = data["Countries"].select { |c| c["CountryCode"] == "TW" }.first
    taiwan["Country"] = "台灣"

    top10 = data["Countries"].sort_by { |c| -c["TotalConfirmed"] }[0..10]

    list << global
    list << taiwan
    list << top10

    list.flatten
  end
end
