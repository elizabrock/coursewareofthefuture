Fabricator(:question) do
end

Fabricator(:boolean_question, from: :question) do
  question_type Question::BOOLEAN
  question "Are you good?"
end

Fabricator(:free_text_question, from: :question) do
  question_type Question::FREE_TEXT
  question "How goes it?"
end
