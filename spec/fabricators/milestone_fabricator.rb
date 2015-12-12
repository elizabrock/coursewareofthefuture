Fabricator(:milestone) do
  deadline { 2.days.from_now }
  title { "Fabricated Milestone" }
  instructions { "Add a fabricator to your project" }
end
