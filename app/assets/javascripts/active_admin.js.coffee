#= require active_admin/base
#= require app

$ ->
  $('.attributes_table.candidate input').each (index, field) ->
    $(field).on 'change', false, ->
      $(this).removeClass('different').removeClass('new').removeClass('blank').addClass('changed')

  $("a.apply").each (index, link) ->
    $(link).on 'click', false, ->
      field_to_fill = $($(this).prop("rel"))
      value_to_fill_in = $(this).siblings('input').attr('value')
      field_to_fill.val(value_to_fill_in).trigger('change')
      false

  new App
    el: $('#main_content')
