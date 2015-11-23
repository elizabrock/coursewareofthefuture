require 'rails_helper'

describe CoveredMaterial do
  it { should belong_to :course }
  it { should validate_presence_of :covered_on }
  it { should validate_presence_of :material_fullpath }
  it { should validate_uniqueness_of(:material_fullpath).scoped_to(:course_id).with_message("should be covered once per course") }
end
