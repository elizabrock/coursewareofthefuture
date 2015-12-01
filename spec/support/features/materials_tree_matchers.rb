def hash_of(path)
  list = first(:css, path)
  result = []
  return result unless list
  child_lis = list.all("li").to_a
  child_lis.each do |li|
    hash = { }
    hash[:title] = li.find("> span.title").text
    if li.has_css?("> span.title a")
      link = li.find("> span.title a")
      hash[:path] = link["href"].gsub(/\/courses\/\d+\/materials\//, "").gsub("%2F", "/")
    end
    result << hash
  end
  result
end

def materials_list
  [
    { title: "Intro to Ruby" },
    { title: "Intro to Ruby", path: "01-intro-to-ruby/intro-to-ruby.md"},
    { title: "Computer Science" },
    { title: "Logic" },
    { title: "Logic", path: "computer-science/logic/logic.md"},
    { title: "Truth Tables", path: "computer-science/logic/truth-tables.md" },
    { title: "Programming" },
    { title: "Advanced Programming" },
    { title: "Garbage Collection", path: "computer-science/programming/advanced-programming/garbage-collection.md" },
    { title: "Basic Programming" },
    { title: "Control Structures" },
    { title: "Basic Control Structures", path: "computer-science/programming/basic-programming/control-structures/basic-control-structures.md" },
    { title: "Data Structures and Types" },
    { title: "Booleans and Bits" },
    { title: "Booleans and Bits", path: "computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" },
    { title: "Functional Programming" },
    { title: "Introduction to Functional Programming", path: "computer-science/programming/functional-programming/introduction-to-functional-programming.md" },
    { title: "Life Skills" },
    { title: "Life Skills", path: "life-skills/life-skills.md" },
    { title: "Rails" },
    { title: "ActionView" },
    { title: "ERB and Haml", path: "rails/actionview/erb-and-haml.md" },
    { title: "Ruby Ecosystem" },
    { title: "Nyan Cat", path: "rails/ruby-ecosystem/nyan-cat.md" }
  ]
end

def materials_hash
  [
    { title: "Intro to Ruby",
      children: [
        { title: "Intro to Ruby",
          path: "01-intro-to-ruby/intro-to-ruby.md" } ]
    },
    { title: "Computer Science",
      children: [
        { title: "Logic",
          children: [
            { title: "Logic",
              path: "computer-science/logic/logic.md"},
            { title: "Truth Tables",
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
                      children: [
                        { title: "Booleans and Bits",
                          path: "computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" }
                      ]
                    }
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
    { title: "Life Skills",
      children: [
        { title: "Life Skills", path: "life-skills/life-skills.md" },
      ]
    },
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
end

def material_titles
  materials_list.map do |material|
    material.has_key?(:path) ? material[:title] : nil
  end.compact.sort
end
