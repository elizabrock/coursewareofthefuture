require 'rails_helper'

RSpec.describe ReadMaterial, :type => :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :material_fullpath }
end
