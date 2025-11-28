class CalendarController < ApplicationController
  def index
    @events = Event.includes(:track).order(:date)
    @tracks = Track.all
  end
end
