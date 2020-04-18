class Coronavirus::Data
  KEYWORDS = {
    "Global" => "全球",
    "NewConfirmed" => "最新確診人數",
    "TotalConfirmed" => "總確診人數",
    "NewDeaths" => "最新死亡人數",
    "TotalDeaths" => "總死亡人數",
    "NewRecovered" => "最新治癒人數",
    "TotalRecovered" => "總治癒人數"
  }

  def initalize(timestamp=Time.zone.now.strftime("%Y%m%d%k"))
    # renew by every hour
    @timestamp = timestamp
    @data = nil
  end

  def process
    @data = get_summary
    parsed_data = JSON.parse(@data)
    list = get_list(parsed_data)
    humanize_data(list)
  end

  private

  def get_summary
    Rails.cache.fetch(@timestamp, expires_in: 90.minutes) do
      HTTParty.get('https://api.covid19api.com/summary').body
    end
  end

  def humanize_data(list)
    content = ""
    list.map do |row|
      country_data = "#{row["Country"]}"
      row.each_pair do |key, value|
        next unless KEYWORDS[key]
        country_data += "\n - #{KEYWORDS[key]}: #{value}"
      end
      country_data += "\n"
      content += country_data
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
