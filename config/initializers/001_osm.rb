require 'ostruct'
require 'yaml'
osm_config = YAML.load_file(Rails.root.join('config', 'osm.yml'))
OpenStreetMapConfig = OpenStruct.new osm_config[Rails.env]

