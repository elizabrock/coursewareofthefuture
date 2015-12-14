module Features
  module ActionHelpers
    def div_labeled(label)
      find(:css, "label", text: label).find(:xpath, "..")
    end

    def milestone(identifier)
      find("h2, legend", text: "#{identifier}").find(:xpath, "..")
    end

    def populate_quiz_submission(quiz_submission, list_of_answers)
      list_of_answers.each do |row|
        question = Question.where(question: row[:question]).first
        answer = row[:answer]
        score = row[:score].to_i
        quiz_submission.question_answers.for(question).first.update_attributes(answer: answer, score: score)
      end
    end

    def within_li_for(topic, &block)
      li = find(:xpath, "//li[./span[@class='title' and contains(normalize-space(.),'#{topic}')]]")
      within(li, &block)
    end

    def mark_as_read(topic)
      within_li_for(topic){ click_button "Mark as Read" }
    end

    def mark_as_covered(topic, options = {})
      within_li_for(topic) do
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
