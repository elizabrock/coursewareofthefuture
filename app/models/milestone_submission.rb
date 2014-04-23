class MilestoneSubmission < ActiveRecord::Base
  belongs_to :milestone
  belongs_to :user

  validates_presence_of :milestone
  validates_presence_of :repository
  validates_presence_of :user
end
