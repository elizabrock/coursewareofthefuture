module QuizHelper
  def grading_summary(question)
    if question.boolean?
      question.question + " (Automatically Graded)"
    else
      need_grades_count = question.question_answers.ungraded.count
      if need_grades_count > 0
        link_text = "#{question.question} (#{need_grades_count} pending grades)"
      else
        link_text = "#{question.question} (Graded)"
      end
      link_to link_text, edit_question_grade_path(question)
    end
  end

  def simple_form_type_for(question)
    if question.boolean?
      :radio_buttons
    else
      :text
    end
  end
end
