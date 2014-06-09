require 'rails_helper'

describe Milestone do
  it { should have_many :milestone_submissions }
end
