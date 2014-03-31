Fabricator(:quiz) do
  deadline { 3.days.from_now }
end

Fabricator(:unpublished_quiz, from: :quiz) do
  deadline nil
end
