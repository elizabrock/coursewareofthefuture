require 'spec_helper'

describe Prerequisite do
  it { should respond_to :assignment }
  it { should belong_to :assignment }
end

