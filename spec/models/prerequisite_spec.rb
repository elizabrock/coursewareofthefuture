require 'rails_helper'

describe Prerequisite do
  it { should belong_to :assignment }
  it { should validate_presence_of :assignment }
  it { should validate_presence_of :material_fullpath }
end
