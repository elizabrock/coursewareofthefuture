require 'rails_helper'

describe User do
  it { is_expected.to validate_presence_of :github_access_token }
  it { is_expected.to have_many :milestone_submissions }
  it { is_expected.to have_many :read_materials }
  it { is_expected.to have_many :quiz_submissions }
end
