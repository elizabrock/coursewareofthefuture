def hash_of(path)
  table = first(:css, path)
  result = []
  return result unless table
  data_trs = table.all("tr").to_a
  data_trs.each do |tr|
    hash = { level: tr["data-level"] }
    if tr.has_css?("td.title a")
      link = tr.find("td.title a")
      hash[:title] = link.find("span").text
      hash[:path] = link["href"].gsub(/\/courses\/\d+\/materials\//, "").gsub("%2F", "/")
    else
      hash[:title] = tr.find("span.title").text
    end
    result << hash
  end
  result
end

def materials_list
  [
    { level: "1", title: "Intro to Ruby" },
    { level: "2", title: "Intro to Ruby", path: "01-intro-to-ruby/intro-to-ruby.md"},
    { level: "1", title: "Computer Science" },
    { level: "2", title: "Logic" },
    { level: "3", title: "Logic", path: "computer-science/logic/logic.md"},
    { level: "3", title: "Truth Tables", path: "computer-science/logic/truth-tables.md" },
    { level: "2", title: "Programming" },
    { level: "3", title: "Advanced Programming" },
    { level: "4", title: "Garbage Collection", path: "computer-science/programming/advanced-programming/garbage-collection.md" },
    { level: "3", title: "Basic Programming" },
    { level: "4", title: "Control Structures" },
    { level: "5", title: "Basic Control Structures", path: "computer-science/programming/basic-programming/control-structures/basic-control-structures.md" },
    { level: "4", title: "Data Structures and Types" },
    { level: "5", title: "Booleans and Bits" },
    { level: "6", title: "Booleans and Bits", path: "computer-science/programming/basic-programming/data-structures-and-types/booleans-and-bits/booleans-and-bits.md" },
    { level: "3", title: "Functional Programming" },
    { level: "4", title: "Introduction to Functional Programming", path: "computer-science/programming/functional-programming/introduction-to-functional-programming.md" },
    { level: "1", title: "Life Skills" },
    { level: "2", title: "Life Skills", path: "life-skills/life-skills.md" },
    { level: "1", title: "Rails" },
    { level: "2", title: "ActionView" },
    { level: "3", title: "ERB and Haml", path: "rails/actionview/erb-and-haml.md" },
    { level: "2", title: "Ruby Ecosystem" },
    { level: "3", title: "Nyan Cat", path: "rails/ruby-ecosystem/nyan-cat.md" }
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
