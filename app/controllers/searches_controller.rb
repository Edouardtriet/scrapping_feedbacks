class SearchesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_search, only: [:show]

  COUNTRIES = [
    "United States", "United Kingdom", "France", "Germany", "Spain"
  ].freeze

  def index
    @searches = current_user.searches.order(created_at: :desc)
  end

  def show
    @reviews = @search.reviews.order(created_at: :desc)
    unless @search.user == current_user
      redirect_to searches_path, alert: "You don't have access to this search"
    end
  end

  def new
    @search = Search.new
    @countries = COUNTRIES
    @recent_searches = current_user.searches.order(created_at: :desc).limit(5) if user_signed_in?
  end

  def create
    @search = current_user.searches.new(search_params)
    if @search.save
      redirect_to search_path(@search), notice: 'Analysis started successfully.'
    else
      @countries = COUNTRIES
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_search
    @search = Search.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to searches_path, alert: "Analysis not found"
  end

  def search_params
    params.require(:search).permit(:app_name, :store_type, :country, :additional_countries, :start_date, :end_date)
  end
end
