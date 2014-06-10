class SelfReportsController < ApplicationController
  def create
    self_report = current_user.self_reports.build(self_report_params)
    @self_report = self_report

    if self_report.save
      render action: "show"
    else
      render action: "new"
    end
  end

  def show
      render action: "show"
  end

  private
  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date)
  end
end
