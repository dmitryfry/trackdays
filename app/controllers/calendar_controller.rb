class CalendarController < ApplicationController
  def index
    @events = Event.includes(:track).scheduled.order(:date)
    @tracks = Track.order(:name)
  end
end
