require 'rails_helper'

describe Event do
  it { is_expected.to belong_to :course }
  it { is_expected.to validate_presence_of :course }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :summary }
end
