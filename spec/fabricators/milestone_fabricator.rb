Fabricator(:milestone) do
  assignment
  deadline { 2.days.from_now }
end
