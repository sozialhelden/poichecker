require 'builder'
require 'httparty'

module Overpass
  extend ActiveSupport::Concern

  module ClassMethods

    def find(osm_id, osm_type='node')
      query = Candidate.to_query(osm_id, osm_type)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => query }).parsed_response['elements']

      if element_hash = parse_for_element(result, osm_type)
        element_hash.delete("type")

        if osm_type ==  'way'
          members = parse_for_members(result)
          lon,lat = centroid(members)
          element_hash["lon"] ||= lon
          element_hash["lat"] ||= lat
        end

        from_osm(element_hash)
      end
    end

    def centroid(members)
      factory = RGeo::Cartesian.factory
      bbox    = RGeo::Cartesian::BoundingBox.new(factory)
      members.each do |member|
        bbox.add factory.point(member["lon"], member["lat"])
      end
      [bbox.center_x, bbox.center_y]
    end


    def parse_for_members(result)
      result.select{|el| el['type'] == 'node'}
    end

    def parse_for_element(result, osm_type)
      result.select{|el| el['type'] == osm_type}.try(:first)
    end

    def to_query(osm_id, osm_type='node')
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json) do
        builder.tag!("id-query", ref: osm_id, type: osm_type)

        builder.union do
          builder.item
          builder.recurse type:"down"
        end if osm_type == 'way'

        builder.print
      end
      xml
    end

    def from_osm(attribs_hash = {})
      attribs_hash["tags"] ||= {}
      Candidate.new(
        id: attribs_hash["id"],
        name: attribs_hash["tags"]["name"],
        lat: attribs_hash["lat"],
        lon: attribs_hash["lon"],
        street: attribs_hash["tags"]["addr:street"],
        housenumber: attribs_hash["tags"]["addr:housenumber"],
        postcode: attribs_hash["tags"]["addr:postcode"],
        city: attribs_hash["tags"]["addr:city"],
        website: attribs_hash["tags"]["website"],
        phone: attribs_hash["tags"]["phone"],
        wheelchair: attribs_hash["tags"]["wheelchair"]
      )
    end
  end
end
