require 'spec_helper'

describe User do
  it { should validate_presence_of :github_access_token }
  it { should have_many :quiz_submissions }
end
