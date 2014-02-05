class App.Candidate extends Spine.Model
  @configure 'Candidate', 'osm_type', 'osm_id', 'parent_id', 'lat', 'lon', 'license', 'address'
  @extend Spine.Model.Ajax

  full_street: ->
    [(@address.road || @address.footway || @address.pedestrian || @address.bridleway), @address.house_number].join(' ')

  full_city: ->
    [@address.postcode, (@address.city || @address.county)].join(' ')

  name: ->
    @address[@type]