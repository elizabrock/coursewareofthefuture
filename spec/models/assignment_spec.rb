require 'rails_helper'

describe Assignment do
  it { is_expected.to validate_presence_of :course }
end
