Fabricator(:course) do
  title "Test Course"
  syllabus "Foo Bar and Plan"
  start_date {Time.new(2014, 3, 10)} 
  end_date  {Time.new(2014, 3, 10) + 90 } 
  active_course true
end

Fabricator(:inactive_course, from: :course) do
  active_course false
end

Fabricator(:active_course, from: :course) do
  active_course true
end
