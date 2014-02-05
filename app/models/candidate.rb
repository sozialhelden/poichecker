# encoding: UTF-8
class Candidate
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair, :source

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=") and !value.blank?
    end
  end

  def persisted?
    false
  end

  def merge_attributes(other_attributes)
    attribs = self.attributes.dup
    other_attributes.each do |key,value|
      attribs[key] ||= value
    end
    attribs.delete("id")
    attribs
  end

  def valid_keys
    [
      :id,
      :name,
      :street,
      :housenumber,
      :postcode,
      :city,
      :wheelchair,
      :website,
      :phone,
      :lat,
      :lon
    ]
  end

  def attributes()
    self.valid_keys.inject(ActiveSupport::HashWithIndifferentAccess.new) do |a,key|
      value = send(key)
      a[key.to_s] = value
      a
    end
  end

  class << self
    def find(osm_id, osm_type='node')
      text = Candidate.to_query(osm_id, osm_type)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => text })
      members = result.parsed_response['elements'].select{|el| el['type'] == 'node'}
      lon,lat = centroid(members)
      attribs_hash = result.parsed_response['elements'].select{|el| el['type'] == osm_type}.try(:first)
      attribs_hash.delete("type")
      attribs_hash["lon"] = lon
      attribs_hash["lat"] = lat
      Candidate.from_osm(attribs_hash)
    end

    def to_query(osm_id, osm_type='node')
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json) do
        builder.tag!("id-query", ref: osm_id, type: osm_type)

        builder.union do
          builder.item
          builder.recurse type:"down"
        end

        builder.print
      end
      xml
    end

    def centroid(members)
      factory = RGeo::Cartesian.factory
      bbox    = RGeo::Cartesian::BoundingBox.new(factory)
      members.each do |member|
        bbox.add factory.point(member["lon"], member["lat"])
      end
      [bbox.center_x, bbox.center_y]
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
        pos: attribs_hash["pos"]
      )
    end
  end
end
