require 'rails_helper'

feature "Instructor manages notes", js:true do

  let!(:new_course) { Fabricate(:course,
    start_date: 7.days.ago,
    end_date: 10.days.from_now)}
  let!(:joe) { Fabricate :student, name: "joe", courses: [new_course] }

  scenario "Creating a note" do
    instructor = Fabricate(:instructor, courses: [new_course])
    instructor.photo_confirmed?.should be_truthy

    signin_as instructor
    visit course_path new_course
    page.should have_css('.count_icon', text:'7')

    fill_in "Note", with: "New Note"
    find(:button, "Noted", visible: true).trigger('click')
    Note.where(content: "New Note").count.should == 1

  end
  # 
  # scenario "Failing to create a course" do
  #   instructor = Fabricate(:instructor, courses: [new_course])
  #   instructor.photo_confirmed?.should be_truthy
  #
  #   signin_as instructor
  #   visit course_path new_course
  #   find(:button, "Noted", visible: false).trigger('click')
  #   page.should have_content "must be in the form of username/repo"
  #   click_button "Create Course"
  #   page.should have_content "Course couldn't be created"
  #   page.should have_error_message("can't be blank", on: "Title")
  #   page.should have_error_message("can't be blank", on: "Source Repository")
  #   fill_in "Title", with: "Cohort 4"
  #   fill_in "Start Date", with: "2014/01/24"
  #   fill_in "End Date", with: "2014/03/24"
  #   fill_in "Source Repository", with: "elizabrock/source"
  #   click_button "Create Course"
  #   page.should have_content "Course successfully created"
  #   Course.where(title: "Cohort 4",
  #                start_date: "2014/01/24", end_date: "2014/03/24").count.should == 1
  #   end
  #
  # scenario "Only the information for the active course is shown to students" do
  #   Fabricate(:course, title: "Cohort 3", end_date: 1.month.ago)
  #   Fabricate(:course, title: "Cohort 4", end_date: 4.days.from_now)
  #   Fabricate(:course, title: "Cohort 5", end_date: 2.months.from_now)
  #   signin_as :student
  #   visit root_path
  #   page.should have_button("Join Cohort 4")
  #   page.should have_button("Join Cohort 5")
  # end
  #
  # scenario "Editing a course that already exists" do
  #   Fabricate(:course, title: "Cohort 4")
  #   signin_as(:instructor)
  #   visit courses_path
  #   click_on 'edit'
  #   Course.where(title: "Homemade Ice Cream Making 101").count.should == 0
  #   fill_in "Title", with: "Homemade Ice Cream Making 101"
  #   click_button "Update Course"
  #   page.should have_content "Course successfully updated"
  #   Course.where(title: "Homemade Ice Cream Making 101").count.should == 1
  # end

end
