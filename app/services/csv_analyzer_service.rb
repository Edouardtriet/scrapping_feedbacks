require 'csv'

class CsvAnalyzerService
  def initialize(csv_path)
    @csv_path = csv_path
    @client = OpenAI::Client.new
  end

  def analyze(question)
    # Determine if this is a chart request
    is_chart_request = question.downcase.include?('chart') ||
                      question.downcase.include?('graph') ||
                      question.downcase.include?('plot') ||
                      question.downcase.include?('visualization')

    # For large CSV files, read a sample to avoid token limits
    csv_content = read_csv_sample(500) # Read first 500 rows

    if is_chart_request
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "You are a CSV analysis assistant that creates charts. Analyze the CSV data and return a JSON object with chart configuration that can be used by Chart.js. Include 'chartType' (bar, line, pie, etc), 'labels', 'datasets', and any other required properties. Also include a brief explanation of the chart." },
            { role: "user", content: "CSV Data:\n#{csv_content}\n\nQuestion: #{question}" }
          ],
          temperature: 0.7,
          max_tokens: 1500
        }
      )
    else
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "You are a CSV analysis assistant. Analyze the following CSV data and answer the user's question." },
            { role: "user", content: "CSV Data:\n#{csv_content}\n\nQuestion: #{question}" }
          ],
          temperature: 0.7,
          max_tokens: 1000
        }
      )
    end

    content = response.dig("choices", 0, "message", "content")

    if is_chart_request
      # Add chart indicator to the response
      { type: "chart", content: content }
    else
      { type: "text", content: content }
    end
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
