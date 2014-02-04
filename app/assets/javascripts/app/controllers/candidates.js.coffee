$ = Spine.$
Candidate = App.Candidate

$.fn.candidate = ->
  elementID = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Candidate.find(elementID)

class App.Candidates extends Spine.Controller
  # elements:
  #   '#index_table_candidates': 'candidate_table'
  #   '#map'                   : 'map_placeholder'

  # events:
  #   'click .item': 'itemClick'

  tag: "tbody"

  constructor: ->
    super
    Candidate.bind 'refresh change', @render

  init: ->
    @candidate_table = $('#index_table_candidates tbody')
    @map_placeholder = $('#map')

    @parent_id  = $('#app').data('parent')
    @lat        = $('#app').data('lat')
    @lon        = $('#app').data('lon')
    @name       = $('#app').data('name')
    @place       = $('#app').data('place')
    @params = {
      url: "http://nominatim.openstreetmap.org/search?" + $.param(
        q: "#{@name}, #{@place}"
        format: "jsonv2"
        addressdetails: 1
        limit: 10
        dedupe: 1
        "accept-language": "de"
      )
      processData: true

    }
    App.Candidate.fetch(@params)

  render_table: (candidates, parent_id) =>
    @candidate_table.html(@view('candidates/index')(candidates: candidates, parent_id: parent_id))

  render_map: (candidates, lat, lon) =>
    @map_placeholder.html(@view('candidates/map')(candidates: candidates, lat: lat, lon: lon))

  render: =>
    candidates = Candidate.all()
    @render_table(candidates, @parent_id)
    @render_map(candidates, @lat, @lon)
#    @html @template(candidates)
