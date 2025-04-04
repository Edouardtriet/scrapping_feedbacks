# app/services/csv_analyzer_service.rb
require 'csv'

class CsvAnalyzerService
  def initialize(csv_path)
    @csv_path = csv_path
    @client = OpenAI::Client.new
  end

  def analyze(question)
    # For large CSV files, read a sample to avoid token limits
    csv_content = read_csv_sample(500) # Read first 1000 rows

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "You are a CSV analysis assistant. Analyze the following CSV data and answer the user's question." },
          { role: "user", content: "CSV Data:\n#{csv_content}\n\nQuestion: #{question}" }
        ],
        temperature: 0.7,
        max_tokens: 1000 # Adjust as needed
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  private

  def read_csv_sample(max_rows)
    rows = []
    headers = nil

    CSV.foreach(@csv_path, headers: true).with_index do |row, i|
      if i == 0
        headers = row.headers.join(',')
        rows << headers
      end

      break if i >= max_rows
      rows << row.fields.join(',')
    end

    rows.join("\n")
  end
end
