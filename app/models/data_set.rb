require 'csv'

class DataSet < ActiveRecord::Base

  validates :license, presence: true
  validates :name, uniqueness: { scope: :data_set_id }

  has_many :nodes

  def import(csv_file)
    CSV.parse(csv_file, headers: true, encoding: 'UTF-8', force_quotes: true, header_converters: :symbol) do |row|
      node_hash = valid_params(row.to_hash)

      if node = nodes.where(name: node_hash[:name]).first
        node.update_attributes(node_hash)
      else
        nodes.create(node_hash)
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
