Then(/^the database should have these questions:$/) do |table|
  table.hashes.each do |row|
    Question.where(row.symbolize_keys).count.should == 1
  end
end
