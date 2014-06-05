require 'rails_helper'

describe MilestoneSubmission do
  it { should belong_to :milestone }
  it { should validate_presence_of :milestone }
  it { should validate_presence_of :user }
  it { should validate_presence_of :repository }
end
