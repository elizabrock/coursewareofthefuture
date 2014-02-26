# Inquizator

## The Courseware of the Future!

This will be the new courseware for Nashville Software School.

[![Code Climate](https://codeclimate.com/repos/5307947ce30ba0586c0036b3/badges/96fc8f2654322baed5fc/gpa.png)](https://codeclimate.com/repos/5307947ce30ba0586c0036b3/feed)
[![Build Status](https://travis-ci.org/elizabrock/coursewareofthefuture.png?branch=master)](https://travis-ci.org/elizabrock/coursewareofthefuture)
[![Coverage Status](https://coveralls.io/repos/elizabrock/coursewareofthefuture/badge.png?branch=master)](https://coveralls.io/r/elizabrock/coursewareofthefuture?branch=master)


## Deployment Instructions

### First Deployment

1. `heroku create inquizator`
2. `git push heroku master`
    * You may need to run `heroku keys:add`
3. `heroku run rake db:migrate`

### For debugging:

1. `heroku logs --tail`

### Subsequent Deployments

1. `git push heroku master`
2. `heroku run rake db:migrate`

### Resources

Notes on Resources:

* https://education.github.com/guide
* https://github.com/elizabrock/NSS-Syllabus-Fall-2012
* https://github.com/elizabrock/NSS-Syllabus-Spring-2013
* https://github.com/elizabrock/NSS-Syllabus-Cohort-3
* http://planbookedu.com/planbooks/view/pk:XRSD8
* https://canvas.instructure.com/courses/790528
* http://www.volunteerspot.com/login/entry/135623132021#/form

Notes to Eliza:

* Need to set up Figaro
* Sortable Tree Options:
  * https://github.com/the-teacher/the_sortable_tree
  * https://www.google.com/search?q=nested+drag+and+drop+activeadmin&oq=nested+drag+and+drop+activeadmin&aqs=chrome..69i57.9711j0j7&sourceid=chrome&espv=210&es_sm=91&ie=UTF-8
  * https://github.com/nebirhos/activeadmin-sortable-tree
  * https://github.com/neo/activeadmin-sortable

## Name Ideas

* Stapler Labs
* Ruby Ruler
* Ruby Whiteboard
* Ruby Student
* Ruby Education
* Ruby Sharpener
* Course Portfolio
* Ruby Binder
* Ruby Pupil


Toolbox
Socrates

## Vision

* course outline
* course materials ("lessons", sort of)
  * wiki-style
  * discussion/commenting
* quizzes
* grading
* projects
  * project checkins

.panel
  %h2 Topics Outline

  This will be an outline of the course topics

.panel
  %h2 Assignments and Quizzes

  This will be an outline of upcoming deadlines

.panel
  %h2 Feedback

  This will be an outline of past deadlines


## Modeling

* Course Session
  * attr: start_date
  * attr: end_date
  * Days Off
    * date
* Students
  * CheckinCompletions


courseware:  connect to github, grade projects, give feedback

quizzes: auto grade, with regex? And just give them answers and explanation afterwards.


## System Dependencies

## Setup Instructions

## Deployment Instructions
