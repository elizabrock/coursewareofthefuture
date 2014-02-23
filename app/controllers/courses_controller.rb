class CoursesController < ApplicationController
  expose(:course){ Course.active }
end
