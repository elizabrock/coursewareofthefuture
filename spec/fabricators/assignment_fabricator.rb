Fabricator(:assignment) do
  published true
end

Fabricator(:published_assignment, from: :assignment)
