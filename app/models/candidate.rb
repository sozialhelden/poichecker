# encoding: UTF-8
class Candidate < ActiveRecord::Base
  include Overpass

  attr_accessor :data_set_id, :original_id, :country

  validates :lat, :lon, presence: true

  # We do not want to save something to the database.
  def save
    true
  end

  def merge_attributes(other_attributes)
    attribs = self.attributes.dup
    other_attributes.each do |key,value|
      attribs[key] ||= value
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

  def attributes()
    self.class.valid_keys.inject(ActiveSupport::HashWithIndifferentAccess.new) do |a,key|
      value = send(key)
      a[key.to_s] = value
      a
    end
  end

  def build(attribs)
    self.class.new(attribs)
  end
end
