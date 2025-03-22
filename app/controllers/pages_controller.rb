class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # Simple home page rendering the home view
    #the search form in the view wil lbe directed to the search controller
  end
end
