# encoding: UTF-8
require 'csv/string_converter'

class Place < ActiveRecord::Base
  include Geo
  include Overpass

  belongs_to :data_set

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lon # ActiveRecord

  def full_address
    [[street, housenumber].join(' '),[postcode, city].join(' '), country].compact.join(', ')
  end

  def self.import(csv_file, data_set)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', force_quotes: true, header_converters: :string) do |row|
      place_hash = valid_params(row.to_hash)
      if place = data_set.places.where(name: place_hash[:name]).first
        place.update!(place_hash)
      else
        begin
          data_set.places.create!(place_hash)
        rescue Exception => e
          raise place_hash.inspect
        end
      end
    end
  end

  def merge_attributes(other_attributes)
    attribs = self.attributes.dup
    other_attributes.each do |key,value|
      attribs[key] ||= value
    end
    attribs.delete("id")
    attribs
  end

  def source
    "Original"
  end

  private

  def self.valid_keys
    [
      :osm_id,
      :name,
      :lat,
      :lon,
      :street,
      :housenumber,
      :postcode,
      :city,
      :phone,
      :wheelchair
    ]
  end

  def self.valid_params(attr_hash)
    ActionController::Parameters.new(attr_hash).permit(valid_keys)
  end

end

