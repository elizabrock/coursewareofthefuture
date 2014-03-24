Fabricator(:course) do
  title "Test Course"
  syllabus "Foo Bar and Plan"
  source_repository "elizabrock/inquizator-test-repo"
  start_date { Date.today }
  end_date { Date.today + 90 }
end
