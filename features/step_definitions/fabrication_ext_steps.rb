Then(/^the database should have these ([^"]*):$/) do |model_name, table|
  klass = Fabrication::Cucumber::StepFabricator.new(model_name).klass
  table.hashes.each do |row|
    klass.where(row.symbolize_keys).count.should == 1
  end
end
