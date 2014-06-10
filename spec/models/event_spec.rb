require 'rails_helper'

describe Event do
  it { should belong_to :course }
  it { should validate_presence_of :course }
  it { should validate_presence_of :date }
  it { should validate_presence_of :summary }
end
