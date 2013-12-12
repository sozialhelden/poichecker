class Node < ActiveRecord::Base
  belongs_to :data_set

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lon # ActiveRecord

  def full_address
    [[street, housenumber].join(' '),[postcode, city].join(' '), country].compact.join(', ')
  end
end
