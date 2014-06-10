class MilestoneSubmissionMailer < ActionMailer::Base

  def notify_instructors(milestone_submission)
    @student_name = milestone_submission.user.name
    @milestone = milestone_submission.milestone
    @assignment = @milestone.assignment

    instructors = @assignment.course.users.instructors
    subject = "New Submission for #{@assignment.title}"

    return if instructors.empty?

    mail to: instructors.map(&:email), subject: subject
  end
end
