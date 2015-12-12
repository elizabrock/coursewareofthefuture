Fabricator(:assignment) do
  title "Test Assignment #1"
  course
  after_build do |assignment|
    assignment.start_date ||= assignment.course.start_date + 1
  end
end

Fabricator(:published_assignment, from: :assignment) do
  published true
  after_build do |assignment|
    if assignment.milestones.empty?
      assignment.milestones.build(Fabricate.attributes_for(:milestone, assignment: assignment, deadline: course.end_date))
    end
  end
end

Fabricator(:unpublished_assignment, from: :assignment) do
  published false
end
