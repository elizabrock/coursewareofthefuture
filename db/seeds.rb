# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Fabricate(:active_course)
course = Course.new(:start_date "2014-03-15", :end_date "2014-06-15", :syllabus "test syllabus", :title "Seed Course", :active_course true)
course.save