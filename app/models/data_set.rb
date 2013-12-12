# encoding: UTF-8
require 'csv'

class DataSet < ActiveRecord::Base

  validates :license, presence: true
  validates :name, uniqueness: true

  has_many :nodes

  def import(csv_file)
    CSV.parse(csv_file, headers: true, force_quotes: true, encoding: 'UTF-8', header_converters: :symbol) do |row|
      node_hash = valid_params(row.to_hash)

      if node = nodes.where(name: node_hash[:name]).first
        node.update_attributes(node_hash)
      else
        begin
          nodes.create!(node_hash)
        rescue Exception => e
          raise node_hash.inspect
        end
      end
    end
  end

  private

  def valid_params(attr_hash)
    ActionController::Parameters.new(attr_hash).permit(:osm_id,
      :name,
      :lat,
      :lon,
      :street,
      :housenumber,
      :postcode,
      :city,
      :phone,
      :wheelchair
    )
  end
end
