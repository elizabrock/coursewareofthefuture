class CoursesController < ApplicationController
  expose(:current_course){ Course.find_by_id(params[:id]) }

  before_filter :require_instructor!, except: [:show]
end
