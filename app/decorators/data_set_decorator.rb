class DataSetDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates :data_set

  def orte
    link_to "Check now: #{model.places.unmatched.count}/#{model.places.count}", admin_data_set_places_path(model), class: 'light-button'
  end

end