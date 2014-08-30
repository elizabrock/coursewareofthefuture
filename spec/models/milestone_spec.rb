require 'rails_helper'

describe Milestone do
  it { is_expected.to have_many :milestone_submissions }
end
