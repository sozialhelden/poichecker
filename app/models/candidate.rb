# encoding: UTF-8
# == Schema Information
#
# Table name: candidates
#
#  id          :integer          not null, primary key
#  place_id    :integer
#  lat         :float
#  lon         :float
#  name        :string(255)
#  housenumber :string(255)
#  street      :string(255)
#  postcode    :string(255)
#  city        :string(255)
#  website     :string(255)
#  phone       :string(255)
#  wheelchair  :string(255)
#  osm_id      :integer
#  osm_type    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Candidate < ActiveRecord::Base
  include Overpass

  attr_accessor :data_set_id, :original_id, :country, :matcher_id, :location, :osm_key, :osm_value

  validates :lat, :lon, presence: true

  # We do not want to save something to the database.
  def save
    true
  end

  def merge_attributes(other_attributes)
    attribs = self.attributes.dup
    other_attributes.each do |key,value|
      attribs[key] ||= value if self.respond_to?(key)
    end
    attribs.delete("id")
    attribs
  end

  def self.valid_keys
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

  def tags
    [
      :name,
      :street,
      :housenumber,
      :postcode,
      :city,
      :wheelchair,
      :website,
      :phone,
    ].inject(ActiveSupport::HashWithIndifferentAccess.new) do |a,key|
      value = send(key)
      a[key.to_s] = value unless value.blank?
      a
    end
  end

  def attributes
    self.class.valid_keys.inject(ActiveSupport::HashWithIndifferentAccess.new) do |a,key|
      value = send(key)
      a[key.to_s] = value
      a
    end
  end

  def as_json(options={})
    super(:methods =>[:osm_id, :osm_type])
  end

  def build(attribs)
    self.class.new(attribs)
  end

  def location
    @location ||= RGeo::Cartesian::Factory.new.parse_wkt("Point(#{self.lon || 0.0 } #{self.lat || 0.0})")
  end
end
