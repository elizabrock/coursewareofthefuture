def hash_of(path)
  list = first(:css, path)
  actual = hash_list(list)
end

def materials_hash
  [
    { title: "Computer Science",
      children: [
        { title: "Logic",
          children: [
            { title: "Logic",
              path: "materials/computer-science/logic/logic.md"},
            { title: "Truth Tables",
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
                      children: [
                        { title: "Booleans and Bits",
                          path: "materials/computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" }
                      ]
                    }
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
    { title: "Life Skills",
      children: [
        { title: "Life Skills", path: "materials/life-skills/life-skills.md" },
      ]
    },
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

def remove_links(hash_array)
  return unless hash_array
  hash_array.each do |hash|
    hash.delete(:path)
    remove_links(hash[:children])
  end
end

def hash_list(list)
  result = []
  return result unless list
  list_items = list.all(:xpath, "./li")
  list_items.each do |li|
    li_hash = { }
    if li.has_xpath?("./div/a")
      link = li.find(:xpath, "./div/a")
      li_hash[:title] = link.find("span").text
      li_hash[:path] = link["href"]
    else
      li_hash[:title] = li.find(:xpath, ".//span[@class='title']").text
    end
    children = hash_list(li.first(:xpath, "./ul"))
    li_hash[:children] = children unless children.blank?
    # e.g. li_hash = { title: title, path: path, children: children }
    result << li_hash
  end
  result
end
