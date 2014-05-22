# encoding: UTF-8
ActiveAdmin.register Place do
  decorate_with PlaceDecorator

  config.sort_order = "distance_asc"

  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :country, :website, :phone, :wheelchair, :osm_key, :osm_value

  belongs_to :data_set, optional: true

  actions :all, :except => [:destroy, :create]
  config.batch_actions = false

  scope :all,       :if => proc { current_admin_user.admin? }
  scope :matched,   :if => proc { current_admin_user.admin? }
  scope :unmatched, :if => proc { current_admin_user.admin? }, :default => true

  filter :data_set,     :if => proc { current_admin_user.admin? }
  filter :name,         :if => proc { current_admin_user.admin? }
  filter :street,       :if => proc { current_admin_user.admin? }
  filter :housenumber,  :if => proc { current_admin_user.admin? }
  filter :city,         :if => proc { current_admin_user.admin? }
  filter :postcode,     :if => proc { current_admin_user.admin? }

  action_item only: :index  do
    link_to edit_location_admin_account_path(current_admin_user) do
      fa_icon('dot-circle-o', text: 'Standort ändern')
    end
  end

  action_item only: :index, if: -> { can?(:upload_csv, Place) }  do
    link_to upload_csv_admin_places_path do
      fa_icon('upload', text: 'Upload CSV')
    end
  end

  collection_action :next, title: false do
    if next_place = find_collection.first
      redirect_to admin_place_path(next_place)
    else
      redirect_to admin_places_path, notice: "Das war der letzte Ort."
    end
  end

  collection_action :upload_csv, title: "Upload Dataset" do
    authorize! :upload_csv, Place
    render "/admin/places/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    authorize! :upload_csv, Place
    tmp_file = place_params[:csv_file].read
    data_set = DataSet.find(place_params[:data_set_id])
    Place.import(tmp_file, data_set)
    redirect_to({:action => :index}, :notice => "CSV imported successfully!")
  end

  controller do

    before_filter :ensure_location

    private

    def ensure_location
      redirect_to edit_location_admin_account_path(current_admin_user), alert: 'Bitte lege Deinen Standort fest.' unless current_admin_user.location
    end

    def place_params
      params.require('place').permit(:data_set_id, :csv_file)
    end

    def scoped_collection
      end_of_association_chain.with_distance_to(current_admin_user.location).with_coordinates
    end

  end

  index title: proc{ I18n.t('places.index.headline', count: Place.unmatched.with_coordinates.count) }, :default => true, :download_links => false do
    if current_admin_user.email.blank?
      panel "E-Mail Adresse fehlt", id: 'mail_missing' do
        span "Gib deine"
        span do
          link_to "E-Mail Adresse", edit_admin_account_path(current_admin_user)
        end
        span "an, und wir benachrichtigen Dich über neue POIs in Deiner Nähe."
      end
    end

    h1 "Dein Ortswissen ist gefragt." do
      span link_to("Jetzt ersten POI checken", first_path), class: "small"

    end
    selectable_column
    column :name do |place|
      link_to place.name, admin_place_path(place, params)
    end
    column :address, sortable: :street
    column "Entfernung zu deinem Standort", :distance

    render partial: 'hide_sidebar'

  end

  show title: "Checke diesen POI" do
    table_options = {
      :id => "index_table_#{active_admin_config.resource_name.plural}",
      :sortable => false,
      :class => "index_table index",
      :i18n => active_admin_config.resource_class
    }

    columns id: "match_view" do
      column span: 2 do
        table_for [resource], table_options do |t|
          t.column fa_icon("map-marker") do |place|
            span "●", class: :circle
          end
          t.column :name
          t.column :address, :address_with_contact_details
        end

        h2 "Kandidaten"

        table_for [], table_options.merge(id: "index_table_candidates") do |t|
          t.column fa_icon("map-marker"), :pos
          t.column :name
          t.column :address, :address_with_contact_details
          t.column "Match?" do |c|
            link_to icon(:check), admin_place_candidate_path(place.id, c.id), class: 'light-button'
          end
        end

        panel I18n.t('places.show.actions'), id: :actions do
          render partial: "actions", locals: { place: place }
        end

        render partial: "spine_app"

      end
      column span: 3 do
        panel "Map" do
          render partial: "map"
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
      f.input :osm_id
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
