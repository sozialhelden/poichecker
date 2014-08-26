#= require i18n
#= require i18n/translations
#= require active_admin/base
#= require leaflet
#= require app

$ ->
  I18n.defaultLocale = 'de'
  I18n.locale        = 'de'

  $('.attributes_table.candidate input').each (index, field) ->
    $(field).on 'change', false, ->
      $(this).removeClass('different').removeClass('new').removeClass('blank').addClass('changed')

  $("a.apply").each (index, link) ->
    $(link).on 'click', false, ->
      field_to_fill = $($(this).prop("rel"))
      value_to_fill_in = $(this).siblings('input').val()
      field_to_fill.val(value_to_fill_in).trigger('change')
      false

  if (el = $('#match_view')).length > 0
    new App
      el: el
