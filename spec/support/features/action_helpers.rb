module Features
  module ActionHelpers

    def div_labeled(label)
      parent = find(:css, "label", text: label).parent
    end

    def milestone(identifier)
      find("h2, legend", text: "#{identifier}").parent
    end

    def populate_quiz_submission(quiz_submission, list_of_answers)
      list_of_answers.each do |row|
        question = Question.where(question: row[:question]).first
        answer = row[:answer]
        score = row[:score].to_i
        quiz_submission.question_answers.for(question).first.update_attributes(answer: answer, score: score)
      end
    end

    def within_tr_for(topic, &block)
      tr = find(:xpath, "//tr[.//a/span[@class='title' and contains(normalize-space(.),'#{topic}')]]")
      within(tr, &block)
    end

    def mark_as_read(topic)
      within_tr_for(topic){ click_button "Mark as Read" }
    end

    def mark_as_covered(topic, options = {})
      within_tr_for(topic) do
        if date = options[:on]
          fill_in "Date", with: date
        end
        click_button "Mark as Covered"
      end
    end

  end
end

RSpec.configure do |config|
  config.include Features::ActionHelpers, type: :feature
end
