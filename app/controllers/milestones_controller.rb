class MilestonesController < ApplicationController
  expose(:assignments){ current_course.assignments }
  expose(:assignment)
  expose(:milestones){ assignment.milestones }
  expose(:milestone)
  expose(:milestone_submissions){ milestone.milestone_submissions }

  before_filter :require_instructor!
end
