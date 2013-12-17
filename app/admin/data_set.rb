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
      link_to data_set.nodes.count, admin_data_set_nodes_path(data_set)
    end
    default_actions

  end
end
