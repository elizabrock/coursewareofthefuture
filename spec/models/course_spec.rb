require 'rails_helper'

describe Course do
  it { should have_many :assignments }
  it { should have_many :covered_materials }
  it { should have_many :events }
  it { should have_many :enrollments }
  it { should have_many :quizzes }
  it { should validate_presence_of :title }
  it { should validate_presence_of :syllabus }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :source_repository }
end
