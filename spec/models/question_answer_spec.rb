require 'spec_helper'

describe QuestionAnswer do
  it { should belong_to :question }
  it { should belong_to :quiz_submission }
  it { should validate_presence_of :question }
  it { should validate_presence_of :quiz_submission }
end
