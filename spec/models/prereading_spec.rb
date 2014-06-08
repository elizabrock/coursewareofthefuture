require 'spec_helper'

describe Prereading do
  it { should respond_to :assignment }
  it { should belong_to :assignment }
end

