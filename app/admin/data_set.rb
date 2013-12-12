# encoding: UTF-8
ActiveAdmin.register DataSet do

  menu :label => proc{ "Datensätze" }
  permit_params :name, :license

  action_item :only => :index  do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv, :title => "Upload Dataset" do

    render "/admin/data_sets/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    tmp_file = data_set_params[:csv_file].read
    data_set = DataSet.find_or_create_by(name: data_set_params[:name], license: data_set_params[:license])
    data_set.import(tmp_file)
    redirect_to({:action => :index}, :notice => "CSV imported successfully!")
  end

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

  controller do
    private

    def data_set_params
      params.require('data_set').permit(:name, :license, :csv_file)
    end
  end

end
