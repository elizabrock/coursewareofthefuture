Fabricator(:course) do
  title "Test Course"
  syllabus "Foo Bar and Plan"
  start_date { Date.today }
  end_date { Date.today + 90 }
  active_course true
end

Fabricator(:inactive_course, from: :course) do
  active_course false
end

Fabricator(:active_course, from: :course) do
  active_course true
end
