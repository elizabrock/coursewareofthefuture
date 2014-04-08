require 'spec_helper'

describe SelfReport do
  it { should validate_presence_of :user }
  it { should validate_presence_of :date }
end
