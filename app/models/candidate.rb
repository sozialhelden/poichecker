# encoding: UTF-8
class Candidate
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include Overpass

  attr_accessor :id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair, :osm_id, :osm_type

  validates :lat, :lon, presence: true

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

  def attributes()
    self.valid_keys.inject(ActiveSupport::HashWithIndifferentAccess.new) do |a,key|
      value = send(key)
      a[key.to_s] = value
      a
    end
  end
end
