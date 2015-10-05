require 'rails_helper'

describe Question do
  it { should belong_to :quiz }
  it { should have_many :question_answers }
  it { should validate_presence_of :quiz }
  it { should validate_presence_of :question }
  it { should validate_presence_of :question_type }
  it { should validate_presence_of :correct_answer }
  it { should validate_inclusion_of(:question_type).in_array(%w{boolean free_text}) }
  context "correct answer validation" do
    context "for a boolean question" do
      let(:question){ Question.new(question_type: "boolean") }
      it { question.should validate_inclusion_of(:correct_answer).in_array(["true", "false", "True", "False"]) }
    end
    context "for a free text question" do
      let(:question){ Question.new(question_type: "free_text") }
      it { question.should_not validate_inclusion_of(:correct_answer).in_array(["true", "false"]) }
    end
  end
end
