class EventsController < ApplicationController
  expose(:events){ current_course.events }
  expose(:event, attributes: :event_params)

  expose(:first_of_each_month_of_course){ (current_course.start_date.change(day: 1)..current_course.end_date).select{ |d| d.day == 1 } }

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
