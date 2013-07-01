namespace :import do

  task :artist_list do
    require 'csv'
    base_statement = "INSERT INTO `reviews` (name, url, created_at, updated_at) VALUES"

    csv_file = ENV["ARTIST_LIST"]
    buffer = []
    CSV.foreach(csv_file) do |row|
      insert_row = [row[0]]
      url = row.detect do |col|
        col.match(/^https?\:\/\//) || col.match(/www\./)
      end

      insert_row << (url || row.last)
      buffer << insert_row

      if buffer.count == 1000
        puts generate_sql(base_statement, buffer)
        buffer.clear
      end
    end

    puts generate_sql(base_statement, buffer)
  end

  def generate_sql(base_statement, values)
    return "" if values.empty?
    value_sql = values.map do |name, url|
      escaped_name = name.gsub("'", %q(\\\'))
      "('#{escaped_name}', '#{url}', '#{Time.now.utc.to_s(:db)}', '#{Time.now.utc.to_s(:db)}')"
    end

    joined_value_sql = value_sql.join(",\r\n")
    "#{base_statement} #{joined_value_sql}"
  end

end
