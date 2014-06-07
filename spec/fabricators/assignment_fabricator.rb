Fabricator(:assignment) do
  course
  published true
end

Fabricator(:published_assignment, from: :assignment)

Fabricator(:unpublished_assignment, from: :assignment) do
  published false
end
