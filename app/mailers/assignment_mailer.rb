class AssignmentMailer < ActionMailer::Base
  def notify_instructor(submission)
    @submission = submission
    @student = @submission.user.name
    @assignment_title = @submission.milestone.assignment.title
    @instructors = @submission.milestone.assignment.course.users.instructors
    subject = "New Submission for #{submission.milestone.assignment.title}"

    @instructors.each do |instructor|
      mail to: instructor.email, subject: subject
    end
  end
end
