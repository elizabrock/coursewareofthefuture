Then(/^I should see the materials tree from the inquizator\-test\-repo$/) do
  expected = [
    { title: "Computer Science",
      children: [
        { title: "Logic",
          path: "computer-science/logic/logic.md",
          children: [ { title: "Truth Tables",
                        path: "computer-science/logic/truth-tables.md" } ]
        },
        { title: "Programming",
          children: [
            { title: "Advanced Programming",
              children: [ { title: "Garbage Collection",
                            path: "computer-science/programming/advanced-programming/garbage-collection.md" } ]
            },
            { title: "Basic Programming",
              children: [
                { title: "Control Structures",
                  children: [
                    { title: "Basic Control Structures",
                      path: "computer-science/programming/basic-programming/control-structures/basic-control-structures.md" }
                  ]
                },
                { title: "Data Structures and Types",
                  children: [
                    { title: "Booleans and Bits",
                      path: "computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" }
                  ]
                }
              ]
            },
            { title: "Functional Programming",
              children: [
                { title: "Introduction to Functional Programming",
                  path: "computer-science/programming/functional-programming/introduction-to-functional-programming.md" }
              ]
            }
          ]
        }
      ]
    },
    { title: "Life Skills", path: "life-skills/life-skills.md" },
    { title: "Rails",
      children: [
        { title: "ActionView",
          children: [ { title: "ERB and Haml", path: "rails/actionview/erb-and-haml.md" } ]
        },
        { title: "Ruby Ecosystem",
          children: [ { title: "Nyan Cat", path: "rails/ruby-ecosystem/nyan-cat.md" } ]
        }
      ]
    }
  ]
  list = first(:css, "ul#materials")
  actual = hash_list(list)
  actual.should == expected
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
