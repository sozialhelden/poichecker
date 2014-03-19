$ = Spine.$
Candidate = App.Candidate

$.fn.candidate = ->
  elementID = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Candidate.find(elementID)

class App.Candidates extends Spine.Controller

  constructor: ->
    super
    Candidate.bind 'refresh change', @render

  init: ->
    @candidate_table = $('#index_table_candidates tbody')
    @map_placeholder = $('#map')
    @spinner         = $('.spinner')

    @parent_id  = $('#app').data('parent')
    @lat        = $('#app').data('lat')
    @lon        = $('#app').data('lon')
    @bbox       = $('#app').data('bbox')
    @name       = $('#app').data('name')
    @place       = $('#app').data('place')
    @params = {
      url: "http://nominatim.openstreetmap.org/search?" + $.param(
        q: "#{@name}, #{@place}"
        viewbox: @bbox
        format: "jsonv2"
        addressdetails: 1
        limit: 9
        dedupe: 1
        "accept-language": "de"
      )
      processData: true

    }
    App.Candidate.fetch(@params)

  stop_spinner: ->
    @spinner.html('')

  render_table: (candidates, parent_id) =>
    @candidate_table.html(@view('candidates/index')(candidates: candidates, parent_id: parent_id))

  render_map: (candidates, lat, lon) =>
    map = L.map("map").setView([
      lat
      lon
    ], 16)
    tiles = L.tileLayer("http://{s}.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/{z}/{x}/{y}.png64",
      attribution: "Map data &copy; <a href=\"http://openstreetmap.org\">OpenStreetMap</a> contributors, <a href=\"http://opendatacommons.org/licenses/odbl/summary/\">ODbL</a>, Tiles © <a href=\"http://mapbox.com\">Mapbox</a>"
      maxZoom: 18
    ).addTo(map)
    circle = L.circle([
      lat
      lon
    ], 150,
      color: "#FE7101"
      weight: 2
      fillColor: "#FE7101"
      fillOpacity: 0.4
    ).addTo(map)

    MarkerIcon = L.Icon.extend(options:
      iconSize: [20, 50]
      iconAnchor: [10, 25]
      popupAnchor: [-3, -26]
    )

    for candidate in candidates
      marker = L.marker([
        candidate.lat
        candidate.lon
      ],
        icon: new MarkerIcon(
          iconUrl: "http://api.tiles.mapbox.com/v3/marker/pin-s-#{_i + 1}.png"
          iconRetinaUrl: "http://api.tiles.mapbox.com/v3/marker/pin-s-#{_i + 1}@2x.png"
        )
      ).addTo(map)

    map.attributionControl.setPrefix ""


  render: =>
    candidates = Candidate.all()
    @render_table(candidates, @parent_id)
    @stop_spinner()
    @render_map(candidates, @lat, @lon)
#    @html @template(candidates)
