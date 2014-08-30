require 'rails_helper'

describe Quiz do
  it { is_expected.to belong_to :course }
  it { is_expected.to have_many :questions }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :course }
end
