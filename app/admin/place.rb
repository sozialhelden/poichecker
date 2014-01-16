# encoding: UTF-8
ActiveAdmin.register Place do
  decorate_with PlaceDecorator

  menu :label => proc{ "Orte" }
  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :country, :website, :phone, :wheelchair

  belongs_to :data_set, optional: true

  actions :all, :except => [:destroy]
  config.batch_actions = false

  action_item :only => :index  do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv, :title => "Upload Dataset" do

    render "/places/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    tmp_file = place_params[:csv_file].read
    data_set = DataSet.find(place_params[:data_set_id])
    Place.import(tmp_file, data_set)
    redirect_to({:action => :index}, :notice => "CSV imported successfully!")
  end



  controller do

    private

    def place_params
      params.require('place').permit(:data_set_id, :csv_file)
    end

  end

  index title: proc{ parent.name rescue 'Orte' }, :default => true do
    selectable_column
    column "Koordinaten" do |place|
      if place.lat && place.lon
        span "#{place.lat || 0.0},#{place.lon || 0.0}"
      else
        span "fehlt"
      end
    end
    column :name
    column :amenity, sortable: :osm_tag do |place|
      if place.osm_key && place.osm_value
        link_to"#{place.osm_key} => #{place.osm_value}","http://wiki.openstreetmap.org/wiki/Tag:#{place.osm_key}%3D#{place.osm_value}"
      else
        span "fehlt"
      end
    end
    column :street
    column :housenumber
    column :postcode
    column :city
    column :website
    column :phone
    column :wheelchair do |place|
      status_tag(place.wheelchair, :class => place.wheelchair)
    end
    column :map do |place|
      if place.lat && place.lon
        link_to "Map", "http://www.openstreetmap.org/#map=17/#{place.lat}/#{place.lon}", target: '_blank', class: 'light-button'
      end
    end
    default_actions
  end

  show do
    table_options = {
      :id => "index_table_#{active_admin_config.resource_name.plural}",
      :sortable => false,
      :class => "index_table index",
      :i18n => active_admin_config.resource_class
    }

    columns do
      column span: 2 do
        table_for [resource], table_options do |t|
          t.column "#" do |place|
            span "★"
          end
          t.column :name
          t.column :street
          t.column :housenumber
          t.column :postcode
          t.column :city
          t.column :website
          t.column :phone
          t.column :wheelchair do |place|
            status_tag(place.wheelchair, :class => place.wheelchair)
          end
        end
      end

      column do
      end
    end

    h2 "Kandidaten"
    columns do
      column span: 2 do

        table_for place.candidates, table_options do |t|
          t.column "#", :pos
          t.column :name
          t.column :full_address
          t.column "Action" do |c|
            link_to "Match", place_candidate_path(place.id, c.id), class: 'light-button'
          end
        end
      end

      column do
        panel "Map" do
          render partial: "map", locals: { candidates: place.candidates }
        end
      end

    end
  end

  form do |f|
    f.inputs "Default" do
      f.input :data_set
      f.input :name
    end
    f.inputs "Adresse" do
      f.input :street
      f.input :housenumber
      f.input :city
      f.input :postcode
      f.input :country,
       :include_blank => 'bitte wählen ...',
       :priority_countries => ['Germany', 'AT', 'CH', 'NL', 'GB', 'FR']
    end
    f.inputs "OpenStreetMap" do
      f.input :osm_key
      f.input :osm_value
      f.input :lat
      f.input :lon
    end
    f.inputs "Zusatz" do
      f.input :website
      f.input :phone
      f.input :wheelchair
    end
    f.actions
  end
end
