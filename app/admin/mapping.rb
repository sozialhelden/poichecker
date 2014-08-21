ActiveAdmin.register Mapping do

  permit_params :locale, :localized_name, :osm_key, :osm_value

end
