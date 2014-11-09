require 'builder'
require 'httparty'
require 'pp'

module Overpass
  extend ActiveSupport::Concern
  include Geo

  included do
    def to_osm_attributes
      osm_attributes_hash = {}

      %w{id lat lon}.each do |key|
        value = send(key)
        osm_attributes_hash[key] = value unless value.blank?
      end
      osm_attributes_hash["tag"] = to_osm_tags

      osm_attributes_hash

    end

    def to_osm_tags
      osm_attributes_hash = {}
      %w{street housenumber postcode city}.each do |key|
        value = send(key)
        osm_attributes_hash["addr:#{key}"] = value unless value.blank?
      end

      %w{name website phone wheelchair}.each do |key|
        value = send(key)
        osm_attributes_hash[key] = value unless value.blank?
      end
      osm_attributes_hash
    end
  end

  module ClassMethods

    def find(osm_id, osm_type='node')
      query = Candidate.to_query(osm_id, osm_type)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => query }).parsed_response['elements']

      if element_hash = parse_for_element(result, osm_type)
        element_hash.delete("type")
        element_hash['osm_id']   ||= osm_id
        element_hash['osm_type'] ||= osm_type

        if osm_type ==  'way'
          members = parse_for_members(result)
          lon,lat = centroid(members)
          element_hash["lon"] ||= lon
          element_hash["lat"] ||= lat
        end

        from_osm(element_hash)
      end
    end

    def search(name, bottom, left, top, right, key=nil, value=nil, osm_types=['node', 'way', 'relation'])
      query = Candidate.to_search_query(name, bottom, left, top, right, key, value, osm_types)
      logger.info(pp query)
      elements = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => query }).parsed_response['elements']
      element_ids = elements.map{|e| e["id"]}

      reject_member_nodes(elements).map do |element|

        # shift id and type attribute as they a reserver keywords in rails
        osm_type = element.delete("type")
        element['osm_type'] ||= osm_type
        element['osm_id']   ||= element['id']

        if osm_type ==  'way'
          # collect the members for way and calculate centroid
          members = member_nodes(element, elements)
          element["lon"],element["lat"]  = centroid(members)
        end

        from_osm(element)
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

    def reject_member_nodes(elements)
      elements.reject do |element|
        member_node_ids(elements).include? element['id']
      end
    end

    def member_node_ids(elements)
      elements.map{|e| e["nodes"]}.flatten.compact
    end

    def member_nodes(element, elements)
      member_ids = element['nodes']
      elements.select do |e|
        member_ids.include?(e['id'].to_i) && e['type'] == 'node'
      end

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

    def to_search_query(name, bottom, left, top, right, key=nil, value=nil, osm_types=['node', 'way', 'relation'])
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json, timeout: 25) do
        builder.comment!("gather results")
        builder.union do
          osm_types.each do |osm_type|

            builder.query type: "#{osm_type}" do
              unless key.blank?
                builder.comment!("query for empty name")
                builder.tag!("has-kv", k: :name, modv: "not", regv: '.' )

                builder.comment!("query for type")
                builder.tag!("has-kv", k: key, regv: to_value_regexp(value) )

                builder.comment!("query for bbox")
                builder.tag!("bbox-query", w: left, s: bottom, e: right, n: top)
              end
            end

            builder.query type: "#{osm_type}" do
              builder.comment!("query for name")
              builder.tag!("has-kv", k: :name, regv: to_name_regexp(name) )
              builder.comment!("ignore public transport")
              builder.tag!("has-kv", k: 'public_transport', modv: "not" )
              # end
              builder.comment!("query for bbox")
              builder.tag!("bbox-query", w: left, s: bottom, e: right, n: top)
            end

          end
        end

        builder.comment!("print results")
        builder.print mode: :body, order: :quadtile

        builder.comment!("find node members for all ways")
        builder.recurse type: 'down'
        builder.print mode: :skeleton, order: :quadtile
      end
      xml
    end

    def to_name_regexp(name)
      name.downcase.gsub(/[\-\.\(\)_&,:+;`´\'\"]/, ' ').  # remove special characters
      gsub(/\s+/, ' ').                                   # remove double white spaces
      strip.                                              # remove leading/trailing whitespace
      split.uniq.                                         # split and dedupe
      reject do |word|
        word.size < 3                                     # We do not want short words
      end.map do |word|
        first_letter = word.first
        "[#{first_letter.upcase}#{first_letter.downcase}]" + word[1..-1]
      end.join('|')
    end

    def to_value_regexp(value)
      value = value.blank? ? '.' : value
      value.is_a?(Array) ? value.join('|') : value
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
        wheelchair: attribs_hash["tags"]["wheelchair"],
        osm_type: attribs_hash["osm_type"],
        osm_id: attribs_hash["osm_id"]
      )
    end

  end
end
