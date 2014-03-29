require 'uri'
require 'cgi'

def selector_for(description)
  case description
  when "the Instructors section"
    ".instructors"
  when "the Students section"
    ".students"
  when /the "(.*)" fieldset/
    page.find(:xpath, "//fieldset[./legend[contains(normalize-space(.), '#{$1}')]]")
  when /the (.*) milestone/
    page.find(:xpath, "//div[contains(@class,'milestone') and ./h2[contains(normalize-space(.), '#{$1}')]]")
  when /the form for (.*)/
    "form##{$1}"
  when /the date (.*)/
    "td[data-date='#{$1}']"
  when "the materials to cover"
    "ul#upcoming_materials"
  when "the materials that have been covered"
    "ol#covered_materials"
  when /Q(\d)/
    page.find(:xpath, "//fieldset[position()=#{$1}]")
  else
    raise "Make a within step for " + description.gsub('"','')
  end
end

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within ([^:]*)$/ do |stepdescription, parent|
  with_scope(parent) { step stepdescription }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |stepdescription, parent, table_or_string|
  with_scope(parent) { step "#{stepdescription}:", table_or_string }
end
