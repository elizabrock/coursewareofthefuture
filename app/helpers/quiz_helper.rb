module QuizHelper
  def simple_form_type_for(question)
    if question.boolean?
      :radio_buttons
    else
      :text
    end
  end
end
