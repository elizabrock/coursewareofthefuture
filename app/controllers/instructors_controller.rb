class InstructorsController < ApplicationController
  before_filter :authenticate!

  def destudentify
    session[:as_student] = nil
    redirect_to :back
  end

  def studentify
    session[:as_student] = true
    redirect_to :back
  end
end
