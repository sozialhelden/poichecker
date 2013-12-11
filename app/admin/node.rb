ActiveAdmin.register Node do

  menu :label => proc{ I18n.t("Node") }
  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair

  index title: 'Orte' do
    selectable_column
    column :lat
    column :lon
    column :name
    column :full_address, sortable: :street
    column :website
    column :phone
    column :wheelchair do |node|
      status_tag(node.wheelchair, :class => node.wheelchair)
    end

    default_actions
  end


end
