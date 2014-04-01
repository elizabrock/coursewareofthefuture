And "show me the page" do
  save_and_open_page
  puts current_path
end

When "I debug" do
  require 'pry'
  binding.pry
  true
end
