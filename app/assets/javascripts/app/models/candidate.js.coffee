class App.Candidate extends Spine.Model
  @configure 'Candidate', 'osm_type', 'osm_id', 'parent_id', 'lat', 'lon', 'license', 'address'
  @extend Spine.Model.Ajax