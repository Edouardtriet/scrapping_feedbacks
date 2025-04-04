# app/controllers/searches_controller.rb
class SearchesController < ApplicationController
  include Wicked::Wizard

  steps :app_name, :store_type, :country, :timeframe

  # Skip the wizard middleware for non-wizard actions
  skip_before_action :setup_wizard, only: [:analyze, :index, :create, :download_csv, :analyze_with_ai]

  def show
    @search = current_user.searches.find_or_initialize_by(id: session[:current_search_id])
    set_countries
    # Initialize select_all. It's checked if ALL countries are in additional_countries
    @select_all = @search.additional_countries.present? && (@countries.map { |c| c[:code] }.sort == @search.additional_countries.sort)
    render_wizard
  end

  def update
    @search = current_user.searches.find_or_initialize_by(id: session[:current_search_id])

    # Set current_step for validations
    @search.current_step = step
    set_countries
    # Handle "Select All" checkbox
    if params[:search][:select_all] == '1'
      params[:search][:additional_countries] = @countries.map { |c| c[:code] }
    elsif params[:search][:additional_countries].nil? # if no countries are selected
      params[:search][:additional_countries] = []
    end

    @search.attributes = search_params

    if @search.valid?
      @search.save if @search.new_record?
      session[:current_search_id] = @search.id
      render_wizard @search
    else
      render_wizard @search
    end
  end

  def create
    @search = current_user.searches.new
    @search.current_step = steps.first
    @search.save(validate: false)
    session[:current_search_id] = @search.id
    redirect_to wizard_path(steps.first, search_id: @search.id)
  end

  def analyze
    @search = Search.find(params[:id])

    # Only use Google Play ID for now
    app_id = @search.google_id

    # Debug information
    Rails.logger.info "Search ID: #{@search.id}"
    Rails.logger.info "App ID: #{app_id.inspect}"
    Rails.logger.info "Google ID: #{@search.google_id.inspect}"
    Rails.logger.info "Apple ID: #{@search.apple_id.inspect}"

    # Check if app_id is present
    if app_id.blank?
      @error = "Google Play Store ID is missing. Please go back and enter a valid Google Play Store ID (e.g., com.spotify.music)."
      return
    end

    output_file = Rails.root.join("public", "reviews_#{@search.id}.csv")
    script_path = Rails.root.join("lib", "scripts", "extract_reviews.py")

    # Find Python executable - try virtual env first, fall back to system Python
    venv_python = Rails.root.join(".venv", "bin", "python3")
    python_cmd = if File.exist?(venv_python)
                   venv_python.to_s
                 elsif system("which python3 > /dev/null 2>&1")
                   "python3"
                 else
                   "python"
                 end

    Rails.logger.info "Using Python: #{python_cmd}"
    Rails.logger.info "Script path exists? #{File.exist?(script_path)}"

    Rails.logger.info "Executing command:"
    command = "#{python_cmd} #{script_path} #{app_id} #{output_file}"
    Rails.logger.info command

    # Capture output and errors
    output = `#{command} 2>&1`
    result = $?.success?

    Rails.logger.info "Command output: #{output}"
    Rails.logger.info "Command result: #{result}"
    Rails.logger.info "File exists? #{File.exist?(output_file)}"

    if result && File.exist?(output_file)
      @csv_url = "/reviews_#{@search.id}.csv"
    else
      @error = "Failed to generate CSV file. Error details: #{output}"
    end
  end

  def download_csv
    app_id = params[:id]
    raise
    csv_data = `python3 path/to/your/script.py #{app_id} -`  # Output to stdout

    send_data csv_data,
              type: "text/csv",
              filename: "reviews_#{app_id}.csv",
              disposition: "attachment"
  end

  def analyze_with_ai
    @search = Search.find(params[:id])
    csv_path = Rails.root.join("public", "reviews_#{@search.id}.csv")

    question = params[:question].presence || "Analyze this CSV data and provide insights about the app reviews."

    begin
      analyzer = CsvAnalyzerService.new(csv_path.to_s)
      result = analyzer.analyze(question)

      # Return the appropriate response format
      render json: result
    rescue => e
      error_message = "Error analyzing CSV: #{e.message}"
      Rails.logger.error("CSV Analysis Error: #{e.message}\n#{e.backtrace.join("\n")}")
      render json: { type: "error", content: error_message }, status: :unprocessable_entity
    end
  end

  def finish_wizard_path
    search = Search.find(session[:current_search_id])
    analyze_search_path(search)
  end

  private

  def search_params
    params.require(:search).permit(
      :app_name,
      :store_type,
      :apple_id,
      :google_id,
      :country,
      :start_date,
      :end_date,
      additional_countries: []
    )
  end

  def set_countries
    @countries = [
      { code: 'US', name: 'United States' },
      { code: 'GB', name: 'United Kingdom' },
      { code: 'FR', name: 'France' },
      { code: 'DE', name: 'Germany' },
      { code: 'ES', name: 'Spain' },
      { code: 'CA', name: 'Canada' }
    ]
  end
end
