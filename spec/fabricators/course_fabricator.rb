Fabricator(:course) do
  title "Test Course"
  source_repository "elizabrock/inquizator-test-repo"
  end_date { Date.today + 30 }
  after_build do |course|
    course.start_date ||= course.end_date - 30
  end
end

Fabricator(:course_with_instructor, from: :course) do
  after_create do |course|
    course.users << Fabricate(:instructor)
  end
end

Fabricator(:past_course, from: :course) do
  start_date { Date.today - 60 }
  end_date { Date.today - 30 }
end
