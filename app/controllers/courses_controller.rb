class CoursesController < ApplicationController
  skip_before_filter :authenticate!
end
