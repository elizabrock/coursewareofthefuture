# http://www.chadcf.com/blog/jqueryui-datepicker-rails-and-simpleform-easy-way
$ ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      dateFormat: "yy-mm-dd"
