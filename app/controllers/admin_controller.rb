class AdminController < ApplicationController
  def index
    @events = Event.includes(:track).order(:date)
  end
end
