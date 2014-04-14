require 'spec_helper'

describe QuizSubmission do
  it { should belong_to :quiz }
  it { should have_many :question_answers }
  it { should belong_to :user }
  it { should validate_presence_of :question_answers }
  it { should validate_presence_of :quiz }
  it { should validate_presence_of :user }
  describe "#update_grade!" do
    let(:quiz){ Fabricate(:populated_quiz) }
    context "when the quiz hasn't been submitted" do
      it "should leave the score nil" do
        quiz_submission = Fabricate(:unfinished_quiz_submission, quiz: quiz)
        quiz_submission.update_grade!
        quiz_submission.grade.should be_nil
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
        quiz_submission.grade.should be_nil
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
        quiz_submission.grade.should == 66
      end
    end
    context "when the score should change to 100%" do
      it "should be" do
        quiz_submission = Fabricate(:submitted_quiz_submission, quiz: quiz)
        answers = quiz_submission.question_answers
        answers[0].update_attributes(score: 1)
        answers[1].update_attributes(score: -1)
        answers[2].update_attributes(score: 1)
        quiz_submission.grade.should == 66
        answers[1].update_attributes(score: 1)
        quiz_submission.update_grade!
        quiz_submission.grade.should == 100
      end
    end
  end
end
