class PlaceDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates :place

  def wheelchair_status
    arbre model: model do
      status_tag(model.wheelchair, class: model.wheelchair) unless model.wheelchair.blank?
    end
  end

  def distance
    number_to_human(model.distance_to(current_admin_user), units: :distance, precision: 2) unless model.location.blank?
  end

  def matching_status
    if model.osm_id
      colum_header = fa_icon("check-square-o")
      arbre model: model do
        status_tag class: 'yes' do
          colum_header
        end
      end

    else
      colum_header = fa_icon("square-o")
      arbre model: model do
        status_tag class: 'no' do
          colum_header
        end
      end

    end

  end


#  def matching_status
#    arbre model: model do status_tag(fa_icon "check-square-o", class: 'matched') end
#    if model.osm_id
#      arbre { status_tag(fa_icon "check-square-o", class: 'matched') }
#    else
#      arbre { status_tag(fa_icon "square-o", class: 'unmatched') }
#    end
#  end

  def address
    model.address_with_contact_details
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
