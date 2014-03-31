require 'spec_helper'

describe QuizSubmission do
  it { should belong_to :quiz }
  it { should have_many :question_answers }
  it { should belong_to :user }
end
