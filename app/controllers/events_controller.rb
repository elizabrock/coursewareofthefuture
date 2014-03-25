class EventsController < ApplicationController
  expose(:events){ current_course.events }
  expose(:event, attributes: :event_params)

  before_filter :require_instructor!, except: [:index]

  def create
    if event.save
      redirect_to course_calendar_path(current_course), notice: "Event successfully created."
    else
      flash.alert = "Event couldn't be created."
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:summary, :date)
  end
end
