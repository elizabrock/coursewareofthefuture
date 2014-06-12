Fabricator(:self_report) do
  user
  attended false
  hours_coding 5
  hours_learning 5
  hours_slept 8
  date { Date.today }
end
