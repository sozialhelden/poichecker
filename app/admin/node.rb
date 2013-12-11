ActiveAdmin.register Node do
  permit_params :data_set_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair
end
