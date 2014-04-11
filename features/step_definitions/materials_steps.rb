def materials_hash
  [
    { title: "Computer Science",
      children: [
        { title: "Logic",
          path: "materials/computer-science/logic/logic.md",
          children: [ { title: "Truth Tables",
                        path: "materials/computer-science/logic/truth-tables.md" } ]
        },
        { title: "Programming",
          children: [
            { title: "Advanced Programming",
              children: [ { title: "Garbage Collection",
                            path: "materials/computer-science/programming/advanced-programming/garbage-collection.md" } ]
            },
            { title: "Basic Programming",
              children: [
                { title: "Control Structures",
                  children: [
                    { title: "Basic Control Structures",
                      path: "materials/computer-science/programming/basic-programming/control-structures/basic-control-structures.md" }
                  ]
                },
                { title: "Data Structures and Types",
                  children: [
                    { title: "Booleans and Bits",
                      path: "materials/computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" }
                  ]
                }
              ]
            },
            { title: "Functional Programming",
              children: [
                { title: "Introduction to Functional Programming",
                  path: "materials/computer-science/programming/functional-programming/introduction-to-functional-programming.md" }
              ]
            }
          ]
        }
      ]
    },
    { title: "Life Skills", path: "materials/life-skills/life-skills.md" },
    { title: "Rails",
      children: [
        { title: "ActionView",
          children: [ { title: "ERB and Haml", path: "materials/rails/actionview/erb-and-haml.md" } ]
        },
        { title: "Ruby Ecosystem",
          children: [ { title: "Nyan Cat", path: "materials/rails/ruby-ecosystem/nyan-cat.md" } ]
        }
      ]
    }
  ]
end

Then(/^I should see the materials tree from the inquizator\-test\-repo with links$/) do
  expected = materials_hash
  list = first(:css, "ul#upcoming_materials")
  actual = hash_list(list)
  actual.should == expected
end

Then(/^I should see the materials tree from the inquizator\-test\-repo with no links$/) do
  expected = materials_hash
  remove_paths(expected)
  list = first(:css, "ul#upcoming_materials")
  actual = hash_list(list)
  actual.should == expected
end

def remove_paths(hash_array)
  return unless hash_array
  hash_array.each do |hash|
    hash.delete(:path)
    remove_paths(hash[:children])
  end
end

def hash_list(list)
  result = []
  return result unless list
  list_items = list.all(:xpath, "./li")
  list_items.each do |li|
    li_hash = { }
    if li.has_xpath?("./a")
      link = li.find(:xpath, "./a")
      li_hash[:title] = link.text
      li_hash[:path] = link["href"]
    else
      li_hash[:title] = li.find(:xpath, "./span").text
    end
    children = hash_list(li.first(:xpath, "./ul"))
    li_hash[:children] = children unless children.blank?
    # e.g. li_hash = { title: title, path: path, children: children }
    result << li_hash
  end
  result
end

Then(/^I should not see any of the exercises from Github$/) do
  page.should_not have_content("Exercises")
  page.should_not have_content("Ruby Koans")
end

When(/^I mark "(.*?)" as covered$/) do |item|
  parent = find(:xpath, "//li[./a[contains(normalize-space(.),'#{item}')]]")
  within(parent) do
    click_button "Mark as Covered"
  end
end
