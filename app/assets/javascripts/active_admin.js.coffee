#= require active_admin/base
$ ->
  $("a.apply").each (index, link) ->
    $(link).on 'click', false, ->
      field_to_fill = $($(this).prop("rel"))
      field_to_fill.val($(this).text())
