require 'uri'
require 'cgi'

def selector_for(description)
  case description
  when /the form for (.*)/
    "form##{$1}"
  when /the date (.*)/
    "td[data-date='#{$1}']"
  else
    description.gsub('"','')
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
