class PlaceDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates :place

  def wheelchair_status
    arbre model: model do
      status_tag(model.wheelchair, :class => model.wheelchair)
    end
  end

  def address
    model.address_with_contact_details
  end

  def amenity
    if model.osm_key && model.osm_value
      link_to"#{model.osm_key} => #{model.osm_value}","http://wiki.openstreetmap.org/wiki/Tag:#{model.osm_key}%3D#{model.osm_value}"
    else
      arbre do
        span "fehlt"
      end
    end
  end

  def coordinates

    if model.lat && model.lon
      link_to "#{model.lat.round(3)},#{model.lon.round(3)}", "http://www.openstreetmap.org/#map=17/#{model.lat}/#{model.lon}", target: '_blank', class: 'light-button'
    else
      arbre do
        span "fehlt"
      end
    end
  end

end
