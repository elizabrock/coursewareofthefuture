require 'rails_helper'

describe MilestoneSubmission do
  it { is_expected.to belong_to :milestone }
  it { is_expected.to validate_presence_of :milestone }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :repository }
  describe "after_create" do
    it "should delegate mail creation to the milestone mailer" do

      milestone_submission = Fabricate.build(:milestone_submission)
      mailer = double(deliver: true)

      expect(MilestoneSubmissionMailer).to receive(:notify_instructors).with(milestone_submission).and_return(mailer).once

      milestone_submission.save!
    end
  end
end
