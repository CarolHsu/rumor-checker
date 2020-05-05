namespace :import do
  desc 'fetch ignore_list which from airtable'
  task airtable: :environment do
    response = HTTParty.get(
      AIRTABLE_URL,
      headers: { 'Authorization': "Bearer #{AIRTABLE_TOKEN}" }
    ).to_h
    records = response["records"]
    records_to_ignore = records.select { |r| r["fields"]["skip_check_in_future?"]  }
    return unless records_to_ignore.present?

    formatted_records = records_to_ignore.each_with_object({}) do |record, hash|
      hash[record["id"]] = record["fields"]["Description"]
    end

    File.open(AIRTABLE_YAML, 'w') do |f|
      f.write(formatted_records.to_yaml)
    end
  end
end
