# encoding: UTF-8
ActiveAdmin.register DataSet do

  menu :label => proc{ "Datensätze" }
  permit_params :name, :license

  index title: 'Datensätze' do
    selectable_column
    column :id
    column :name
    column :license
    column :orte do |data_set|
      link_to "Check now: #{data_set.places.count}", data_set_places_path(data_set), class: 'light-button'
    end
    default_actions

  end
end
