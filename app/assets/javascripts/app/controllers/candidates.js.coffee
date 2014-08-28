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
    @place      = $('#app').data('place')
    @phrase     = $('#app').data('phrase')
    @locale     = $('#app').data('locale')
    @params = {
      url: "http://poichecker.dev/admin/places/#{@parent_id}/candidates/suggest"
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
      weight: 3
      color: '#BB2585'
      fillColor: "#BB2585"
      fillOpacity: 0.30
    ).addTo(map)

    MarkerIcon = L.Icon.extend(options:
      iconSize: [30, 70]
      iconAnchor: [15, 35]
      popupAnchor: [-3, -26]
    )

    for candidate in candidates
      marker = L.marker([
        candidate.lat
        candidate.lon
      ],
        icon: new MarkerIcon(
          iconUrl: "http://api.tiles.mapbox.com/v3/marker/pin-m-#{_i + 1}+008472.png"
          iconRetinaUrl: "http://api.tiles.mapbox.com/v3/marker/pin-m-#{_i + 1}+008472@2x.png"
        )
      ).addTo(map)

    map.attributionControl.setPrefix ""


  render: =>
    candidates = Candidate.all()
    @render_table(candidates, @parent_id)
    @stop_spinner()
    @render_map(candidates, @lat, @lon)
#    @html @template(candidates)
