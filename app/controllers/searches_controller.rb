# app/controllers/searches_controller.rb
class SearchesController < ApplicationController
  include Wicked::Wizard

  steps :app_name, :store_type, :country, :timeframe

  # Skip the wizard middleware for non-wizard actions
  skip_before_action :setup_wizard, only: [:analyze, :index, :create]

  def show
    @search = current_user.searches.find_or_initialize_by(id: session[:current_search_id])

    @countries = [
      { code: 'US', name: 'United States' },
      { code: 'GB', name: 'United Kingdom' },
      { code: 'FR', name: 'France' },
      { code: 'DE', name: 'Germany' },
      { code: 'ES', name: 'Spain' },
      { code: 'CA', name: 'Canada' }
    ]

    # Initialize select_all. It's checked if ALL countries are in additional_countries
    @select_all = @search.additional_countries.present? && (@countries.map { |c| c[:code] }.sort == @search.additional_countries.sort)

    render_wizard
  end

  def update
    @search = current_user.searches.find_or_initialize_by(id: session[:current_search_id])

    # Set current_step for validations
    @search.current_step = step

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

    render 'analyze'
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

end
