class StudentsController < ApplicationController
  expose(:students){ User.students }

  skip_before_filter :require_profile!
  skip_before_filter :authenticate!

  def index
  end
end
