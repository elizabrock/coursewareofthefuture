class SelfReportsController < ApplicationController
  def create
    self_report = current_user.self_reports.build(self_report_params)
    @self_report = self_report

    if self_report.save
      format.js { render action: "show" }
    else
      format.js { render action: "new" }
    end
  end

  private
  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date)
  end
end
