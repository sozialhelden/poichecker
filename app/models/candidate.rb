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

  def source
    @source || "OpenStreetMap"
  end


  def valid_keys
    [
      :id,
      :name,
      :lat,
      :lon,
      :street,
      :housenumber,
      :postcode,
      :city,
      :website,
      :phone,
      :wheelchair
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
    def find(osm_id)
      text = Candidate.to_query(osm_id)
      result = HTTParty.post('http://overpass-api.de/api/interpreter', { :body => text })
      attribs_hash = result.parsed_response['elements'].try(:first)
      attribs_hash.delete("type")
      Candidate.from_osm(attribs_hash)
    end

    def to_query(osm_id)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct!
      xml = builder.tag!("osm-script", output: :json) do
        builder.tag!("id-query", ref: osm_id, type: :node)
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
        wheelchair: attribs_hash["tags"]["wheelchair"],
        pos: attribs_hash["pos"]
      )
    end
  end
end
