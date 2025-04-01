# app/controllers/searches_controller.rb
class SearchesController < ApplicationController
  include Wicked::Wizard

  steps :app_name, :store_type, :country, :timeframe

  # Skip the wizard middleware for non-wizard actions
  skip_before_action :setup_wizard, only: [:analyze, :index, :create, :download_csv]

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

    # Define the output file path for the CSV
    output_file = Rails.root.join("public", "reviews_#{@search.id}.csv")

    # Call the Python script to generate the CSV file
    app_id = @search.google_id || @search.apple_id # Use Google or Apple ID based on store type
    script_path = Rails.root.join("lib", "scripts", "extract_reviews.py")

    result = system("python3", script_path.to_s, app_id, output_file.to_s)

    if result && File.exist?(output_file)
      puts "File generated successfully: #{output_file}"
      @csv_url = "/reviews_#{@search.id}.csv"
    else
      puts "Failed to generate file: #{output_file}"
      @error_message = "Failed to generate CSV file. Please try again."
    end

    render 'analyze'
  end

  def download_csv
    app_id = params[:id]
    csv_data = `python3 path/to/your/script.py #{app_id} -`  # Output to stdout

    send_data csv_data,
              type: "text/csv",
              filename: "reviews_#{app_id}.csv",
              disposition: "attachment"
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
