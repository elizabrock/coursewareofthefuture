require 'rails_helper'

describe MilestoneSubmission do
  it { should belong_to :milestone }
  it { should validate_presence_of :milestone }
  it { should validate_presence_of :user }
  it { should validate_presence_of :repository }
  describe "after_create" do
    it "should delegate mail creation to the milestone mailer" do

      milestone_submission = Fabricate.build(:milestone_submission)
      mailer = double(deliver_now: true)

      expect(MilestoneSubmissionMailer).to receive(:notify_instructors).with(milestone_submission).and_return(mailer).once

      milestone_submission.save!
    end
  end
end
