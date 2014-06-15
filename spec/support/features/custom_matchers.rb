RSpec::Matchers.define :have_calendar_entry do |expected, options|
  match do |page|
    date = expected
    message = options[:text]
    page.should have_css("td[data-date='#{date}'] span", text: message)
  end
end

RSpec::Matchers.define :have_exercise_from_github do
  match do |page|
    page.should_not have_content("Exercises")
    page.should_not have_content("Ruby Koans")
  end
end

RSpec::Matchers.define :have_options_for do |field, options|
  match do |page|
    expected_options = options[:options]
    field = page.find_field(field)
    actual_options = field.all("option").map{|o| [o.text]}.flatten
    actual_options.should == expected_options
  end

  failure_message do |page|
    expected_options = options[:options]
    actual_options = page.all("option").map{|o| [o.text]}.flatten
    "expected that #{actual_options} would be a precise match for #{expected_options}"
  end
end

RSpec::Matchers.define :have_list do |contents|
  match do |page|
    contents.each_with_index do |text, row|
      page.should have_xpath("//*/li[#{row+1}][contains(normalize-space(.), '#{text}')]")
    end
  end
end

RSpec::Matchers.define :have_error_message do |text, options|
  match do |page|
    field = options[:on]
    selector = ".//div[contains(@class,'error') and ./label[contains(text(),'#{field}')]]/span[contains(text(),\"#{text}\")]"
    page.should have_xpath(selector)
  end
end
