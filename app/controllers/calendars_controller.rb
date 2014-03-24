class CalendarsController < ApplicationController
  expose(:events){ current_course.events }
end
