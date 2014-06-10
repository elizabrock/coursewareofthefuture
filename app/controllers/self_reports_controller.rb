class SelfReportsController < ApplicationController
  expose(:self_reports){ current_user.self_reports }
  expose(:self_report, attributes: :self_report_params)

  def create
    if self_report.save
      render :show
    else
      render :new
    end
  end

  def update
    if self_report.save
      render :show
      flash[:notice] = "Your self report has been updated!"
    else
      render :edit
      flash[:alert] = "Your update failed"
    end
  end

  private

  def self_report_params
    params.require(:self_report).permit(:attended, :hours_coding, :hours_learning, :hours_slept, :date)
  end
end
