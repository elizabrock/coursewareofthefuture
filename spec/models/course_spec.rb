require 'rails_helper'

describe Course do
  it { is_expected.to have_many :assignments }
  it { is_expected.to have_many :covered_materials }
  it { is_expected.to have_many :enrollments }
  it { is_expected.to have_many :events }
  it { is_expected.to have_many :milestones }
  it { is_expected.to have_many :quizzes }
  it { is_expected.to have_many :users }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { is_expected.to validate_presence_of :source_repository }
end
