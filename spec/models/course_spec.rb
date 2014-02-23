require 'spec_helper'

describe Course do
  it { should have_many :events }
  it { should validate_presence_of :title }
  it { should validate_presence_of :syllabus }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  context "when there is already an active course" do
    before { Fabricate(:active_course) }
    it { should_not allow_value(true).for(:active_course) }
  end
  context "when there isn't an active course" do
    before { Fabricate(:inactive_course) }
    it { should allow_value(true).for(:active_course) }
  end
end
