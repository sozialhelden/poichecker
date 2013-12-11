class Node < ActiveRecord::Base
  belongs_to :data_set

  def full_address
    [[street, housenumber].join(' '),[postcode, city].join(' ')].join(', ')
  end
end
