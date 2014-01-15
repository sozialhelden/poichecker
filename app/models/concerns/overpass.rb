require 'builder'
require 'rgeo'
require 'httparty'

module Overpass
  extend ActiveSupport::Concern

  included do

    attr_accessor :bbox, :factory, :pos, :candidates

    def factory
      @factory ||=  RGeo::Cartesian.factory
    end

    def bbox
      @bbox ||= RGeo::Cartesian::BoundingBox.new(factory)
    end

    def to_bbox
      # return bbox unless bbox.nil?
      center = factory.point(lon, lat)
      bbox.add(center)
      widen_by_meters
      bbox
    end

    def widen_by_meters(meters=1000)
      south_west = factory.point(self.lon - degrees_per_meter_longitude(meters/2) , self.lat - degrees_per_meter_latitude(meters/2))
      north_east = factory.point(self.lon + degrees_per_meter_longitude(meters/2) , self.lat + degrees_per_meter_latitude(meters/2))
      bbox.add(south_west)
      bbox.add(north_east)
    end

    def distance_to(other_node)
      factory.point(lon,lat).distance(factory.point(other_node.lon,other_node.lat)).abs
    end


    def meters_per_degrees_latitude
      111132.92 - (559.82 * Math.cos(2 * self.lat)) + (1.175 * Math.cos(4 * self.lat))
    end

    def meters_per_degrees_longitude
      111412.84 * Math.cos(self.lat) - 93.5 * Math.cos(3 * self.lat)
    end

    def degrees_per_meter_latitude(meters = 1)
      meters / meters_per_degrees_latitude
    end

    def degrees_per_meter_longitude(meters = 1)
      meters / meters_per_degrees_longitude
    end

    def w
      to_bbox.min_x
    end

    def e
      to_bbox.max_x
    end

    def n
      to_bbox.max_y
    end

    def s
      to_bbox.min_y
    end

    def candidates
      @candidates ||= fetch_candidates
    end

    def fetch_candidates
      text = Node.to_query(self)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => text })
      cands = result.parsed_response['elements']

      candidates = cands.map do |c|
        c.delete("type")
        Node.from_osm(c)
      end

      candidates.sort! do |a,b|
        self.distance_to(a) <=> self.distance_to(b)
      end

      candidates = candidates[0...9]

      candidates.each_with_index do |c,i|
        c.pos = i+1
      end
    end

  end
  module ClassMethods

    def to_query(node)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json) do

        builder.union do
          #%w{ node way relation}.each do |t|
          %w{ node }.each do |t|
            builder.query(type: t) do
              builder.tag!("has-kv", k: node.osm_key, v: node.osm_value)
              builder.tag!("bbox-query", e: node.e, n: node.n, s: node.s, w: node.w)
            end
          end
        end

        builder.union do
          builder.item
          builder.recurse type:"down"
        end

        builder.print
      end
      xml
    end

    def from_osm(attribs_hash)
      Node.new(
        id: attribs_hash["id"],
        name: attribs_hash["tags"]["name"],
        lat: attribs_hash["lat"],
        lon: attribs_hash["lon"],
        street: attribs_hash["tags"]["addr:street"],
        housenumber: attribs_hash["tags"]["addr:housenumber"],
        city: attribs_hash["tags"]["addr:city"],
        postcode: attribs_hash["tags"]["addr:postcode"],
        website: attribs_hash["tags"]["website"],
        phone: attribs_hash["tags"]["phone"],
        wheelchair: attribs_hash["tags"]["wheelchair"],
        pos: attribs_hash["pos"]
      )
    end

  end
end
