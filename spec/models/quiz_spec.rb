require 'rails_helper'

describe Quiz do
  it { should belong_to :course }
  it { should have_many :questions }
  it { should validate_presence_of :title }
  it { should validate_presence_of :course }
end
