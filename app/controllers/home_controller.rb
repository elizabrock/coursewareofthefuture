class HomeController < ApplicationController
  skip_before_filter :authenticate_student!
end
