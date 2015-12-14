require 'rails_helper'

describe Assignment do
  it { should validate_presence_of :course }
  it { should validate_presence_of :title }
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
  context "#populate_from_github", vcr: true do
    let(:assignment){ Fabricate(:course).assignments.build }
    before do
      octoclient = Fabricate(:user).octoclient
      assignment.source = source
      assignment.populate_from_github(octoclient)
    end
    context "with a properly formatted exercise" do
      let(:source){ "01-intro-to-ruby/exercises/01-cheers.md" }
      it "should populate the assignment" do
        assignment.title.should == "Cheers"
        assignment.summary.should == "Nullam id dolor id nibh ultricies vehicula ut id elit. Aenean lacinia bibendum nulla sed consectetur."
        assignment.milestones.size.should == 2
        assignment.milestones.first.title.should == "Milestone 1"
        assignment.milestones.first.corequisites.size.should == 2
        assignment.milestones.first.instructions.should start_with("Cras mattis")
        assignment.milestones.last.title.should == "Milestone 2"
        assignment.milestones.last.corequisites.size.should == 1
        assignment.milestones.last.instructions.should start_with("Donec id")
      end
    end
    context "with a exercise that has a title and milestone, but no summary" do
      let(:source){ "exercises/05-half-baked-assignment.md" }
      it "should populate the assignment" do
        assignment.title.should == "Half-Baked Assignment"
        assignment.summary.should == ""
        assignment.milestones.size.should == 1
        assignment.milestones.first.title.should == "Milestone 1"
        assignment.milestones.first.corequisites.size.should == 1
        assignment.milestones.first.instructions.should start_with("Integer posuere")
      end
    end
    context "with a exercise that has a summary, but no title or milestones" do
      let(:source){ "exercises/06-almost-empty-exercise.md" }
      it "should populate the assignment" do
      end
    end
    context "with a exercise that has a summary and milestones, but no title" do
      let(:source){ "exercises/04-unfinished-exercise/unfinished-exercise.md" }
      it "should populate the assignment" do
        assignment.title.should be_nil
        assignment.summary.should start_with("This is in the wrong place")
        assignment.milestones.size.should == 1
        assignment.milestones.first.title.should == "Milestone 1"
        assignment.milestones.first.corequisites.size.should == 1
        assignment.milestones.first.instructions.should start_with("Integer posuere")
      end
    end
    context "with an exercise that has a summary and title, but no milestones" do
      let(:source){ "exercises/07-no-milestones.md" }
      it "should populate the assignment" do
        assignment.title.should == "Ruby Koans"
        assignment.summary.should == "It's time to get started on the [Ruby Koans](http://rubykoans.com/).\n\nFollow the instructions on the Ruby Koans website to get started."
        assignment.milestones.size.should == 0
      end
    end
    context "with an exercise that milestones that have no summaries" do
      let(:source){ "exercises/03-some-other-exercise/instructions.md" }
      it "should populate the assignment" do
        assignment.title.should == "Ruby Koans"
        assignment.summary.should == "It's time to get started on the [Ruby Koans](http://rubykoans.com/).\n\nFollow the instructions on the Ruby Koans website to get started."
        assignment.milestones.size.should == 3
        assignment.milestones[0].title.should == "Strings"
        assignment.milestones[0].corequisites.size.should == 0
        assignment.milestones[0].instructions.should be_nil
        assignment.milestones[1].title.should == "Objects"
        assignment.milestones[1].corequisites.size.should == 0
        assignment.milestones[1].instructions.should be_nil
        assignment.milestones[2].title.should == "Triangles"
        assignment.milestones[2].corequisites.size.should == 0
        assignment.milestones[2].instructions.should be_nil
      end
    end
  end
end
