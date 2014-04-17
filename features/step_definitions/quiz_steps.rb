Given(/^I have a graded quiz submission for that quiz with the following answers:$/) do |table|
  @quiz_submission = Fabricate(:graded_quiz_submission, user: @user, quiz: @quiz)
  populate_quiz_submission(@quiz_submission, table)
end

Given(/^I have an ungraded quiz submission for that quiz with the following answers:$/) do |table|
  @quiz_submission = Fabricate(:ungraded_quiz_submission, user: @user, quiz: @quiz)
  populate_quiz_submission(@quiz_submission, table)
end

When(/^that quiz is graded$/) do
  @quiz_submission.submit!
  @quiz_submission.question_answers.each do |answer|
    if answer.ungraded?
      puts "Updating grade from #{answer.score}"
      answer.score = [-1, 1].sample
      answer.save
    end
  end
  @quiz_submission.should be_graded
end

def populate_quiz_submission(quiz_submission, table)
  table.hashes.each do |row|
    question = Question.where(question: row["question"]).first
    answer = row["answer"]
    score = row["score"].to_i
    quiz_submission.question_answers.for(question).first.update_attributes(answer: answer, score: score)
  end
end
