#= require active_admin/base
#= require app

$ ->
  $("a.apply").each (index, link) ->
    $(link).on 'click', false, ->
      field_to_fill = $($(this).prop("rel"))
      value_to_fill_in = $(this).siblings('input').attr('value')
      field_to_fill.val(value_to_fill_in)
      false

  new App
    el: $('#main_content')
