class PlaceDecorator < ApplicationDecorator
  decorates :place

#   def wheelchair
#     status_tag(model.wheelchair, :class => model.wheelchair)
#   end

  def full_address
    [[model.street, model.housenumber].join(' '),[model.postcode, model.city].join(' '), model.country].compact.join(', ')
  end
end
