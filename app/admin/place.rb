# encoding: UTF-8
ActiveAdmin.register Place do
  decorate_with PlaceDecorator

  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :country, :website, :phone, :wheelchair, :osm_key, :osm_value

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

  filter :data_set
  filter :name
  filter :street
  filter :housenumber
  filter :city
  filter :wheelchair, as: :select, :collection => %w(yes limited no unknown)



  index title: proc{ parent.name rescue 'Orte' }, :default => true do
    selectable_column
    column :coordinates, sortable: :lat
    column :name
    column :amenity, sortable: :osm_tag
    column :address
    column "♿", :wheelchair_status
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
          t.column :address, :address_with_contact_details
        end

        h2 "Kandidaten"

        table_for place.candidates, table_options.merge(id: "index_table_candidates") do |t|
          t.column "#", :pos
          t.column :name
          t.column :address, :address_with_contact_details
          t.column "Match?" do |c|
            link_to "✓", place_candidate_path(place.id, c.id), class: 'light-button'
          end
        end

        panel "Nicht dabei?", class: :right do
          if place.next
            link_to "Next &raquo;".html_safe, data_set_place_path(place.data_set_id, place.next), class: 'light-button'
          else
            link_to "Back &raquo;".html_safe, data_sets_path, class: 'light-button'
          end
        end

        active_admin_comments

        render partial: "spine_app"

      end
      column span: 3 do
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
