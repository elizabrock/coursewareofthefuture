require 'spec_helper'

describe QuizSubmission do
  it { should belong_to :quiz }
  it { should have_many :question_answers }
  it { should belong_to :user }
  it { should validate_presence_of :question_answers }
  it { should validate_presence_of :quiz }
  it { should validate_presence_of :user }
end
