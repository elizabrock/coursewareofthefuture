require 'rails_helper'

describe Milestone do
  it { should have_many :milestone_submissions }
  it { should validate_presence_of :assignment }
  it { should validate_presence_of :title }
  it { should validate_presence_of :instructions }
  context "#deadline_must_be_appropriate" do
    let(:milestone){ Fabricate.build(:milestone) }
    let(:assignment){ Fabricate(:published_assignment,
                                start_date: "2014/10/12",
                                course: Fabricate(:course, start_date: "2014/10/10", end_date: "2014/10/30")) }
    it "should be skipped if there is no assigment" do
      milestone.assignment = nil
      milestone.should_not be_valid
      milestone.errors[:deadline].should be_empty
    end
    it "should be skipped if there is no assigment start date" do
      assignment.start_date = nil
      milestone.assignment = assignment
      milestone.should be_valid
    end
    it "should be skipped if there is no deadline" do
      milestone.assignment = assignment
      milestone.deadline = nil
      milestone.valid?
      # The errors shouldn't be stacked, so "can't be blank" should be present
      # by itself:
      milestone.errors[:deadline].should == ["can't be blank"]
    end
    it "should be invalid if the deadline is before the assignment starts" do
      milestone.assignment = assignment
      milestone.deadline = "2014/10/10"
      milestone.should_not be_valid
      milestone.errors[:deadline].should == ["must be in the assignment timeframe of 10/12 to 10/30"]
    end
    it "should be valid if the deadline is between the beginning of the assignment and the end of the course" do
      milestone.assignment = Fabricate(:assignment,
                                       start_date: "2014/10/12",
                                       course: Fabricate(:course,
                                                         start_date: "2014/10/01",
                                                         end_date: "2014/10/30"))
      milestone.deadline = "2014/10/20"
      milestone.should be_valid
      milestone.errors[:deadline].should be_empty
    end
    it "should be invalid if the deadline is after the course ends" do
      milestone.assignment = assignment
      milestone.deadline = "2014/11/11"
      milestone.should_not be_valid
      milestone.errors[:deadline].should == ["must be in the assignment timeframe of 10/12 to 10/30"]
    end
  end
  context "#publishable?" do
    it "should be false if there is no deadline" do
      Fabricate.build(:milestone, deadline: nil).publishable?.should be_falsey
    end
    it "should be true if there is a deadline" do
      Fabricate.build(:milestone, deadline: 10.days.from_now).publishable?.should be_truthy
    end
  end
  context "#populate_from_markdown", vcr: true do
    let(:assignment){ Fabricate(:course).assignments.build }
    let(:milestone){ assignment.milestones.build }
    let(:expected_instructions){ "Pellentesque ornare sem lacinia quam venenatis vestibulum." }
    before do
      octoclient = Fabricate(:user).octoclient
      course = assignment.course
      materials = Material.materials(octoclient, course.source_repository)
      milestone.populate_from_markdown(source, materials)
    end
    context "blank string" do
      let(:source){ "" }
      it "should not populate the milestone" do
        milestone.title.should be_nil
        milestone.instructions.should be_nil
        milestone.corequisites.should be_empty
      end
    end
    context "only a title and instructions, no corequisites" do
      let(:source){ "## Foo Milestone\nPellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should == expected_instructions
        milestone.corequisites.should be_empty
      end
    end
    context "title, instructions and corequisites" do
      let(:source){ "## Foo Milestone\n> requires: life-skills, nyan-cat\nPellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should == expected_instructions
        milestone.corequisites.map(&:formatted_title).should == ["Life Skills", "Nyan Cat"]
      end
    end
    context "title, instructions, corequisites, with missing corequisites" do
      let(:source){ "## Foo Milestone\n> requires: life-skills, not-there, nyan-cat\nPellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should == expected_instructions
        milestone.corequisites.map(&:formatted_title).should == ["Life Skills", "Nyan Cat"]
      end
    end
    context "title, instructions, corequisites, with malformed corequisites" do
      let(:source){ "## Foo Milestone\n> requires: life-skills nyan-cat\nPellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should == expected_instructions
        milestone.corequisites.should be_empty
      end
    end
    context "only a title and corequisites, and no instructions" do
      let(:source){ "## Foo Milestone\n> requires: life-skills, nyan-cat" }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should be_nil
        milestone.corequisites.map(&:formatted_title).should == ["Life Skills", "Nyan Cat"]
      end
    end
    context "only a title, and no instructions or corequisites" do
      let(:source){ "## Foo Milestone" }
      it "should populate the milestone" do
        milestone.title.should == "Foo Milestone"
        milestone.instructions.should be_nil
        milestone.corequisites.should be_empty
      end
    end
    context "with a instructions, and no corequisites or title" do
      let(:source){ "Pellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should be_nil
        milestone.instructions.should == expected_instructions
        milestone.corequisites.should be_empty
      end
    end
    context "with a instructions and corequisites, and no title" do
      let(:source){ "> requires: life-skills, nyan-cat\nPellentesque ornare sem lacinia quam venenatis vestibulum." }
      it "should populate the milestone" do
        milestone.title.should be_nil
        milestone.instructions.should == expected_instructions
        milestone.corequisites.map(&:formatted_title).should == ["Life Skills", "Nyan Cat"]
      end
    end
    context "with corequisites and no title or instructions" do
      let(:source){ "> requires: life-skills, nyan-cat" }
      it "should populate the milestone" do
        milestone.title.should be_nil
        milestone.instructions.should be_nil
        milestone.corequisites.map(&:formatted_title).should == ["Life Skills", "Nyan Cat"]
      end
    end
  end
end
