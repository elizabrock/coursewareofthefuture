# Inquizator

## The Courseware of the Future!

This will be the new courseware for Nashville Software School.

[![Build Status](https://travis-ci.org/elizabrock/coursewareofthefuture.png?branch=master)](https://travis-ci.org/elizabrock/coursewareofthefuture)
[![Code Climate](https://codeclimate.com/github/elizabrock/coursewareofthefuture.png)](https://codeclimate.com/github/elizabrock/coursewareofthefuture)
[![Code Climate](https://codeclimate.com/github/elizabrock/coursewareofthefuture/coverage.png)](https://codeclimate.com/github/elizabrock/coursewareofthefuture)

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
* http://planbookedu.com/planbooks/view/pk:XRSD8
* https://canvas.instructure.com/courses/790528
* http://www.volunteerspot.com/login/entry/135623132021#/form

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


## System Dependencies

None

## Setup Instructions

1. Copy `config/application.yml.example` to `config/application.yml`
1. Copy `config/database.yml.example` to `config/database.yml`
2. Fill in the correct Github API key and a valid Github access token (see below)
3. `rake db:create:all`
4. `rake db:migrate`
3.  Copy a valid `github_access_token` from a local User (e.g. from logging in on localhost) and save it as `GITHUB_ACCESS_TOKEN` in application.yml.
5. `rake`
6. Confirm that rake passed.  If it didn't, that means your setup is missing something.


### Developer keys

Either get them from Eliza, or set up your own keys, as below:

1. Go to https://github.com/settings/applications and create an application
  * Homepage URL: http://localhost:3000
  * Authorization callback URL: http://localhost:3000/users/auth/github/callback
2. Copy the application keys into your application.yml:
  * Client ID = GITHUB\_CLIENT\_ID
  * Client Secret = GITHUB\_CLIENT\_SECRET

## Deployment Instructions

1. Get Eliza to add you to heroku
2. `git remote add heroku <heroku_git_url>`
3. `git push heroku master`
4. `heroku run rake db:migrate`


## Research Notes:

https://hud.iron.io/tq/projects/53594f0efaed5a000900008e/tasks/53596fb09979ed0d7d025a43/activity?from_date=04%2F23%2F2014&status%5B%5D=error&to_date=04%2F24%2F2014

https://hud.iron.io/tq/projects/53594f0efaed5a000900008e/get_started#

http://dev.iron.io/worker/webhooks/

Trees:

http://www.jqueryrain.com/2014/03/jquery-tabelizer-multi-level-grouping-indicators-tables/

http://www.jqueryrain.com/2012/07/nicetree-jquery-tree-plugin/
