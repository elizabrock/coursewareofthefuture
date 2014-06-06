class SelfReportsController < ApplicationController
  expose(:self_reports){ current_user.self_reports }
  expose(:self_report, attributes: :self_report_params)

  def create
    self_report.save
  end

  def update
    if self_report.save
      redirect_to course_calendar_path(current_course)
      flash[:notice] = "Your self report has been updated!"
    else
      render :edit
      flash[:alert] = "Your update failed"
    end
  end

  private

  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date, :id)
  end
end
