require 'spec_helper'

describe Quiz do
  it { should belong_to :course }
  it { should have_many :questions }
  it { should validate_presence_of :title }
end
