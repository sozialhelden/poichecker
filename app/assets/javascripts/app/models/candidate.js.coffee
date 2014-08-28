class App.Candidate extends Spine.Model
  @configure 'Candidate', 'id', 'osm_id', 'osm_type', 'parent_id', 'lat', 'lon', 'name', 'street', 'housenumber', 'city', 'postcode'
  @extend Spine.Model.Ajax

  full_street: ->
    arr = []
    arr.push(@street) if !!@street
    arr.push(@housenumber) if !!@housenumber
    arr.join(' ')

  full_city: ->
    arr = []
    arr.push(@postcode) if !!@postcode
    arr.push(@city) if !!@city
    arr.join(' ')

  address: ->
    arr = []
    arr.push(@full_street()) if !!@full_street()
    arr.push(@full_city()) if !!@full_city()
    arr.join(', ')

