require 'spec_helper'

describe QuestionAnswer do
  it { should belong_to :question }
  it { should belong_to :quiz_submission }
  it { should validate_presence_of :question }
  it { should validate_presence_of :quiz_submission }
  describe "when quiz is submitted" do
    let(:quiz){ Fabricate(:quiz) }
    let(:true_question_correct){ Fabricate(:boolean_question, correct_answer: "true", quiz: quiz) }
    let(:false_question_correct){ Fabricate(:boolean_question, correct_answer: "false", quiz: quiz) }
    let(:true_question_incorrect){ Fabricate(:boolean_question, correct_answer: "True", quiz: quiz) }
    let(:false_question_incorrect){ Fabricate(:boolean_question, correct_answer: "False", quiz: quiz) }
    let(:free_text_question){ Fabricate(:free_text_question, correct_answer: "Foo", quiz: quiz) }
    let(:quiz_submission){ student.quiz_submissions.build(quiz: quiz) }
    let(:student){ Fabricate(:student) }
    before do
      student.courses << quiz.course
      true_question_correct; false_question_correct; free_text_question
      true_question_incorrect; false_question_incorrect
      quiz_submission.save!
      answers = quiz_submission.question_answers
      answers.for(true_question_correct).first.update_attribute(:answer, true)
      answers.for(true_question_incorrect).first.update_attribute(:answer, false)
      answers.for(false_question_incorrect).first.update_attribute(:answer, true)
      answers.for(false_question_correct).first.update_attribute(:answer, false)
      answers.for(free_text_question).first.update_attribute(:answer, "Bar")
      quiz_submission.reload
      assert quiz_submission.submit!
    end
    context "boolean answers" do
      it "should grade correct true answers" do
        quiz_submission.question_answers.for(true_question_correct).first.score.should == 1
      end
      it "should grade correct false answers" do
        quiz_submission.question_answers.for(false_question_correct).first.score.should == 1
      end
      it "should grade incorrect true answers" do
        quiz_submission.question_answers.for(true_question_incorrect).first.score.should == -1
      end
      it "should grade incorrect false answers" do
        quiz_submission.question_answers.for(false_question_incorrect).first.score.should == -1
      end
    end
    context "free text answers" do
      it "should not grade itself" do
        quiz_submission.question_answers.for(free_text_question).first.score.should == 0
      end
    end
  end
end
