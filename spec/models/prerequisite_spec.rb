require 'spec_helper'

describe Prerequisite do
  it { should belong_to :assignment }
  it { should validate_presence_of :assignment }
  it { should validate_presence_of :materials_fullpath }
end
