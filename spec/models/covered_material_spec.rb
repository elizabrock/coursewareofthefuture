require 'rails_helper'

describe CoveredMaterial do
  it { is_expected.to belong_to :course }
  it { is_expected.to validate_presence_of :covered_on }
  it { is_expected.to validate_presence_of :material_fullpath }
  it { is_expected.to validate_uniqueness_of(:material_fullpath).with_message("should be covered once per course") }
end
