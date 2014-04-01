Fabricator(:quiz_submission) do
  submitted_at { 2.days.ago }
end

Fabricator(:submitted_quiz_submission, from: :quiz_submission) do
end

Fabricator(:unfinished_quiz_submission, from: :quiz_submission) do
  submitted_at nil
end
