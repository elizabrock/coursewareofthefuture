Fabricator(:quiz) do
  course
  title "Foo"
  deadline { 3.days.from_now }
  published true
end

Fabricator(:populated_quiz, from: :quiz) do
  course
  title "Foo"
  deadline { 3.days.from_now }
  after_create { |q| 3.times{ Fabricate(:free_text_question, quiz: q )} }
end

Fabricator(:unpublished_quiz, from: :quiz) do
  deadline nil
  published false
end
