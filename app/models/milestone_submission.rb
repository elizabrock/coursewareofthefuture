class MilestoneSubmission < ActiveRecord::Base
  belongs_to :milestone
  belongs_to :user

  validates_presence_of :milestone
  validates_presence_of :repository
  validates_presence_of :user

  after_create :notify_instructors

  def repository_url
    "https://github.com/#{user.github_username}/#{repository}"
  end

  protected

  def notify_instructors
    MilestoneSubmissionMailer.notify_instructors(self).deliver
  end
end
