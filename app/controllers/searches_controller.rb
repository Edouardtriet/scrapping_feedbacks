class SearchesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_search, only: [:show]

  COUNTRIES = [
    "United States", "United Kingdom", "France", "Germany", "Spain"
  ].freeze

  def index
    @query = params[:query]
    if params[:query].present?
      @app = App.find_by("name ILIKE ?", params[:query])
      if @app
        redirect_to countries_search_path(@app)
        return
      else
        @apps = App.where("name ILIKE ?", "%#{params[:query]}%").limit(5)
        if @apps.count == 1
          redirect_to countries_search_path(@apps.first)
          return
        elsif @apps.empty?
          # Array of fun messages
          messages = [
            "Hmm, I've never heard of '#{params[:query]}'. Are you sure that's a real app? Try something like 'Instagram' or 'TikTok' instead.",
            "Oops! '#{params[:query]}' doesn't seem to exist in our universe. Try a popular app like 'WhatsApp' or 'Facebook'.",
            "'#{params[:query]}'? Is that from the future? For now, try searching for apps like 'Snapchat' or 'YouTube'.",
            "Sorry, I looked everywhere but couldn't find '#{params[:query]}'. How about trying 'Twitter' or 'Pinterest'?"
          ]

          flash[:alert] = messages.sample
          redirect_to root_path
          return
        end
      end
    else
      @apps = []
    end
  end

  def show
    @app = App.find(params[:id])
    redirect_to countries_search_path(@app)
  end

  def suggestions
    @apps = App.where("name ILIKE ?", "%#{params[:query]}%").limit(5)
    render json: @apps.map { |app| { id: app.id, name: app.name, developer: app.developer, icon: app.icon_url } }
  end

  def countries
    @app = App.find(params[:id])
  end

  def timeframe
    @app = App.find(params[:id])
    @selected_countries = params[:countries] || []
  end

  def analyze
    @app = App.find(params[:id])
    @selected_countries = params[:countries] || []
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @time_range = params[:time_range]
  end

  def save_search
    @app = App.find(params[:id])
    @selected_countries = params[:countries] || []

    if user_signed_in?
      @search = current_user.searches.new(
        app_name: @app.name,
        store_type: @app.store_type,
        country: @selected_countries.join(", "),
        end_date: params[:end_date],
        time_range: params[:time_range]
      )

      if @search.save
        flash[:notice] = "Search saved successfully!"
      else
        flash[:alert] = "There was an error saving your search: #{@search.errors.full_messages.join(', ')}"
      end
    else
      flash[:alert] = "You must be logged in to save your search."
      redirect_to login_path
    end
  end

  def autocomplete
    query = params[:query]

    # Ensure the query is at least 2 characters long
    if query.length >= 2
      # Use the model method to get autocomplete suggestions
      suggestions = Search.autocomplete_apps(query)

      respond_to do |format|
        format.json { render json: suggestions }
      end
    else
      respond_to do |format|
        format.json { render json: [] }
      end
    end
  end
end
