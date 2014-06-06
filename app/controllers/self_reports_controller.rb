class SelfReportsController < ApplicationController
  expose(:self_reports){ current_user.self_reports }
  expose(:self_report, attributes: :self_report_params)

  def create
    self_report.save
    render :show
  end

  def update
    if self_report.save
      redirect_to course_calendar_path(current_course)
      flash[:notice] = "Your self report has been updated!"
    else
      render :show
      flash[:alert] = "Your update failed"
    end
  end

  def edit
    @self_report = SelfReport.find(params[:id])
  end

  private

  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date, :id)
  end
end
