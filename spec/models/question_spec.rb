require 'rails_helper'

describe Question do
  it { is_expected.to belong_to :quiz }
  it { is_expected.to have_many :question_answers }
  it { is_expected.to validate_presence_of :quiz }
  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :question_type }
  it { is_expected.to validate_presence_of :correct_answer }
  it { is_expected.to ensure_inclusion_of(:question_type).in_array(%w{boolean free_text}) }
  context "correct answer validation" do
    context "for a boolean question" do
      let(:question){ Question.new(question_type: "boolean") }
      it { expect(question).to ensure_inclusion_of(:correct_answer).in_array(["true", "false", "True", "False"]) }
    end
    context "for a free text question" do
      let(:question){ Question.new(question_type: "free_text") }
      it { expect(question).not_to ensure_inclusion_of(:correct_answer).in_array(["true", "false"]) }
    end
  end
end
