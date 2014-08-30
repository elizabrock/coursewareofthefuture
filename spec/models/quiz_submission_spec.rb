require 'rails_helper'

describe QuizSubmission do
  it { is_expected.to belong_to :quiz }
  it { is_expected.to have_many :question_answers }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :question_answers }
  it { is_expected.to validate_presence_of :quiz }
  it { is_expected.to validate_presence_of :user }
  describe "#update_grade!" do
    let(:quiz){ Fabricate(:populated_quiz) }
    context "when the quiz hasn't been submitted" do
      it "should leave the score nil" do
        quiz_submission = Fabricate(:unfinished_quiz_submission, quiz: quiz)
        quiz_submission.update_grade!
        expect(quiz_submission.grade).to be_nil
      end
    end
    context "when the questions aren't all graded" do
      it "should leave the score nil" do
        quiz_submission = Fabricate(:submitted_quiz_submission, quiz: quiz)
        answers = quiz_submission.question_answers
        answers[0].update_attributes(score: 1)
        answers[1].update_attributes(score: 0)
        answers[2].update_attributes(score: 1)
        #^ This should also trigger update_grade, but I don't want to rely on that for this test.
        quiz_submission.update_grade!
        expect(quiz_submission.grade).to be_nil
      end
    end
    context "when the score should be 66%" do
      it "should be" do
        quiz_submission = Fabricate(:submitted_quiz_submission, quiz: quiz)
        answers = quiz_submission.question_answers
        answers[0].update_attributes(score: 1)
        answers[1].update_attributes(score: -1)
        answers[2].update_attributes(score: 1)
        #^ This should also trigger update_grade, but I don't want to rely on that for this test.
        quiz_submission.update_grade!
        expect(quiz_submission.grade).to eql 66
      end
    end
    context "when the score should change to 100%" do
      it "should be" do
        quiz_submission = Fabricate(:submitted_quiz_submission, quiz: quiz)
        answers = quiz_submission.question_answers
        answers[0].update_attributes(score: 1)
        answers[1].update_attributes(score: -1)
        answers[2].update_attributes(score: 1)
        expect(quiz_submission.grade).to eql 66
        answers[1].update_attributes(score: 1)
        quiz_submission.update_grade!
        expect(quiz_submission.grade).to eql 100
      end
    end
  end
end
