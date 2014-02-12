# encoding: UTF-8
# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  data_set_id :integer
#  original_id :integer
#  osm_id      :integer
#  name        :string(255)
#  lat         :float
#  lon         :float
#  street      :string(255)
#  housenumber :string(255)
#  postcode    :string(255)
#  city        :string(255)
#  country     :string(255)
#  website     :string(255)
#  phone       :string(255)
#  wheelchair  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'csv/string_converter'

class Place < ActiveRecord::Base
  include Geo

  belongs_to :data_set
  has_many :comments, as: :resource, dependent: :destroy, class_name: 'ActiveAdmin::Comment'

  validates :name, :data_set_id, presence: true

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lon # ActiveRecord
  after_validation :geocode, :if => :address_changed?


  scope :with_coordinates, -> { where.not(lat: nil).where.not(lon: nil) }
  scope :matched,          -> { where.not(osm_id: nil) }
  scope :unmatched,        -> { where(osm_id: nil) }

  def address_changed?
    changes.keys.any?{ |key| address_keys.include? key }
  end

  def next
    self.class.where(data_set_id: self.data_set_id).
    where("#{Place.table_name}.id > ?", self.id).
    where(osm_id: nil).
    order(id: :asc).
    limit(1).with_coordinates.
    try(:first)
  end

  def full_address
    [street_info.join(' '),city_info.join(' '), country].reject{|s| s.blank?}.compact.join(', ')
  end

  def street_info
    [street, housenumber].reject{|s| s.blank?}
  end

  def city_info
    [postcode, city].reject{|s| s.blank?}
  end

  def address_with_contact_details
    [full_address, phone, website].reject{|s| s.blank?}.compact.join(', ')
  end

  def self.import(csv_file, data_set)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', header_converters: :string) do |row|
      place_hash = valid_params(row.to_hash)
      begin
        data_set.places.create!(place_hash)
      rescue Exception => e
        raise place_hash.inspect
      end
    end
  end

  def address_keys
    %w{street housenumber city postcode country}
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
      :wheelchair,
      :website,
      :phone,
      :osm_key,
      :osm_value
    ]
  end

  def self.valid_params(attr_hash)
    ActionController::Parameters.new(attr_hash).permit(valid_keys)
  end

end

