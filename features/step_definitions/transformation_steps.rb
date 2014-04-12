Transform /^table:.*user name.*$/ do |table|
  table.tap do |t|
    t.map_headers!('user name' => 'user')
    t.map_column!('user') do |user_name|
      User.find_by_name(user_name)
    end
  end
end

Transform /^table:.*source question.*$/ do |table|
  table.tap do |t|
    t.map_headers!('source question' => 'question_id')
    t.map_column!('question_id') do |question|
      Question.find_by_question(question).id
    end
  end
end

Transform /^table:.*photo_file.*$/ do |table|
  table.tap do |t|
    t.map_headers!('photo_file' => 'photo')
    t.map_column!('photo') do |file_name|
      File.new(File.join(Rails.root, 'features', 'support', 'files', file_name))
    end
  end
end
