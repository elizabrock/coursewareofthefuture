require 'rails_helper'

describe Assignment do
  it { should validate_presence_of :course }
  context "start date validations" do
    it "should not require start_date on unpublished assignments" do
      assignment = Fabricate.build(:unpublished_assignment, start_date: nil)
      assignment.should_not validate_presence_of(:start_date)
      assert assignment.valid?
    end
    it "should require start_date on published assignments" do
      assignment = Fabricate.create(:unpublished_assignment, start_date: nil)
      assert assignment.valid?
      assignment.should_not validate_presence_of(:start_date)
      assignment.published = true
      assignment.should validate_presence_of(:start_date)
      refute assignment.valid?
    end
  end
  context "#start_date_must_be_appropriate" do
    let(:course){ Fabricate(:course, start_date: "2014/10/12", end_date: "2014/11/01") }
    let(:assignment){ Fabricate.build(:assignment, course: course) }
    it "should be skipped if there is no start_date" do
      assignment.start_date = nil
      assignment.valid?
      assignment.errors[:start_date].should be_empty
    end
    it "should be skipped if there is no course" do
      assignment.course = nil
      assignment.start_date = "2013/10/10"
      assignment.valid?
      assignment.errors[:start_date].should be_empty
    end
    it "should be invalid if the start_date is before the course starts" do
      assignment.start_date = "2014/10/11"
      assignment.valid?
      assignment.errors[:start_date].should == ["must be in the course timeframe of 10/12 to 11/01"]
    end
    it "should be valid if the deadline is inside the course dates" do
      assignment.start_date = "2014/11/01"
      assignment.valid?
      assignment.errors[:start_date].should be_empty
    end
    it "should be invalid if the deadline is after the course ends" do
      assignment.start_date = "2014/11/02"
      assignment.valid?
      assignment.errors[:start_date].should == ["must be in the course timeframe of 10/12 to 11/01"]
    end
  end
  context "milestone validations" do
    it "an unpublished assignment without a milestone should be valid" do
      assignment = Fabricate.build(:assignment)
      assignment.milestones = []
      assignment.should be_valid
      # assignment.errors[:milestones].should include("must contain at least one milestone")
    end
    it "a published assignment without a milestone should not be valid" do
      assignment = Fabricate.build(:assignment, start_date: "2014/10/12", published: true)
      assignment.milestones = []
      assignment.should_not be_valid
      assignment.errors[:milestones].should include("must contain at least one milestone")
    end
  end
  context "#publishable?" do
    let(:assignment){ Fabricate(:unpublished_assignment,
                                start_date: "2014/05/14",
                                course: Fabricate(:course, start_date: "2014/05/01"),
                                milestones: [Fabricate.build(:milestone, deadline: "2014/05/15")]
                               )}
    it "should be false if there are no milestones" do
      assignment.start_date = nil
      assignment.publishable?.should be_falsey
    end
    it "should be false if there is no start_date" do
      assignment.milestones = []
      assignment.publishable?.should be_falsey
    end
    it "should be false if there are unpublishable milestones" do
      assignment.milestones << Fabricate.build(:milestone, deadline: nil, assignment: nil)
      assignment.publishable?.should be_falsey
    end
    it "should be true if there is a start_date and milestones" do
      assignment.publishable?.should be_truthy
    end
  end
end
