class CalendarsController < ApplicationController
  expose(:events){ course.events }

  def show
    @event = course.events.new(summary: "Today", date: Time.now.strftime("%Y-%m-%d"))
  end

end
