require 'rails_helper'

describe Assignment do
  it { should validate_presence_of :course }
  it { should have_many :prerequisites }
end
