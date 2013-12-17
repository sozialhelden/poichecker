# encoding: UTF-8
require 'csv/string_converter'
class Node < ActiveRecord::Base
  belongs_to :data_set

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lon # ActiveRecord

  def full_address
    [[street, housenumber].join(' '),[postcode, city].join(' '), country].compact.join(', ')
  end

  def self.import(csv_file, data_set)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', force_quotes: true, header_converters: :string) do |row|
      node_hash = valid_params(row.to_hash)
      if node = data_set.nodes.where(name: node_hash[:name]).first
        node.update!(node_hash)
      else
        begin
          data_set.nodes.create!(node_hash)
        rescue Exception => e
          raise node_hash.inspect
        end
      end
    end
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
