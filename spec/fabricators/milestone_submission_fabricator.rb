Fabricator(:milestone_submission) do
  user
  milestone
  repository "foo/bar"
end
