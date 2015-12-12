require 'rails_helper'

describe Course do
  it { should have_many :assignments }
  it { should have_many :covered_materials }
  it { should have_many :enrollments }
  it { should have_many :events }
  it { should have_many :milestones }
  it { should have_many :quizzes }
  it { should have_many :users }
  it { should validate_presence_of :title }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :source_repository }
  context "#end_date_must_be_appropriate" do
    it "should be invalid if end_date is before start_date" do
      course = Fabricate.build(:course, start_date: "2014/01/01", end_date: "2013/12/31")
      course.valid?
      course.errors[:end_date].should == ["must be after the start date"]
    end
    it "should be invalid if end_date is on the start_date" do
      course = Fabricate.build(:course, start_date: "2014/01/01", end_date: "2014/01/01")
      course.valid?
      course.errors[:end_date].should == ["must be after the start date"]
    end
    it "should be valid if end_date is after start_date" do
      course = Fabricate.build(:course, start_date: "2014/01/01", end_date: "2014/01/02")
      course.valid?
      course.errors[:end_date].should be_empty
    end
    it "should be skipped if end_date is blank" do
      course = Fabricate.build(:course, start_date: "2014/01/01", end_date: "")
      course.valid?
      course.errors[:end_date].should == ["can't be blank"]
    end
    it "should be skipped if start_date is blank" do
      course = Fabricate.build(:course, start_date: "", end_date: "2014/01/02")
      course.valid?
      course.errors[:end_date].should be_empty
    end
  end
end
