require 'builder'
require 'httparty'

module Overpass
  extend ActiveSupport::Concern

  included do

    attr_accessor :pos, :candidates

    def candidates
      @candidates ||= fetch_candidates
    end

    def fetch_candidates
      text = Place.to_query(self)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => text })
      cands = result.parsed_response['elements']

      candidates = cands.map do |c|
        c.delete("type")
        Place.from_osm(c)
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

    def to_query(place)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json) do

        builder.union do
          #%w{ node way relation}.each do |t|
          %w{ node }.each do |t|
            builder.query(type: t) do
              builder.tag!("has-kv", k: place.osm_key, v: place.osm_value)
              builder.tag!("bbox-query", e: place.e, n: place.n, s: place.s, w: place.w)
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
      Place.new(
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
