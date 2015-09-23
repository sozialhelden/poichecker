# encoding: UTF-8
ActiveAdmin.register Place do
  decorate_with PlaceDecorator

  config.sort_order = "distance_asc"

  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon,
                :street, :housenumber, :postcode, :city, :country, :website,
                :phone, :wheelchair, :osm_key, :osm_value, :q, :locale,
                :wheelchair_toilet, :wheelchair_description, :centralkey, :ref_url

  belongs_to :data_set, optional: true

  actions :all, :except => [:destroy, :create]
  config.batch_actions = false

  scope I18n.t('scopes.all'), :all,       :if => proc { current_admin_user.admin? }
  # custom scope not defined on the model

  scope I18n.t('scopes.matched'), :matched, :if => proc { current_admin_user.admin? } do |places|
    places.with_osm_id
  end

  scope I18n.t('scopes.unmatched'), :unmatched, :if => proc { current_admin_user.admin? } do |places|
    places.without_osm_id
  end

  scope I18n.t('scopes.skipped_by_you'), :skipped_by_you,   :if => proc { current_admin_user.admin? } do |places|
    places.without_osm_id.skipped_by(current_admin_user)
  end
  scope I18n.t('scopes.matched_by_you'), :matched_by_you,   :if => proc { current_admin_user.admin? } do |places|
    places.with_osm_id.matched_by(current_admin_user)
  end
  scope I18n.t('scopes.to_do'), :to_do, :default => true, :if => proc { current_admin_user.admin? } do |places|
    places.without_osm_id.unskipped_by(current_admin_user)
  end

  filter :data_set,     :if => proc { current_admin_user.admin? }
  filter :name,         :if => proc { current_admin_user.admin? }
  filter :street,       :if => proc { current_admin_user.admin? }
  filter :housenumber,  :if => proc { current_admin_user.admin? }
  filter :city,         :if => proc { current_admin_user.admin? }
  filter :postcode,     :if => proc { current_admin_user.admin? }

  action_item only: :index  do
    link_to edit_location_admin_account_path(current_admin_user) do
      fa_icon('dot-circle-o', text: I18n.t('header.action_items.edit_location'))
    end
  end

  action_item only: :index, if: -> { can?(:upload_csv, Place) }  do
    link_to upload_csv_admin_places_path do
      fa_icon('upload', text: 'Upload CSV')
    end
  end

  collection_action :next, title: false do

    # add all skipped place ids for current user to actual search query
    if next_place = find_collection.first
      url_for_params = {
        controller: :places,
        action: :show,
        id: next_place.id,
        data_set_id: params[:data_set_id],

      }
      redirect_to url_for(params.permit(:order, :scope).merge(url_for_params))
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

    before_filter :save_skipped_id, only: :next

    private

    def ensure_location
      redirect_to edit_location_admin_account_path(current_admin_user), alert: I18n.t('flash.actions.location_missing.alert') unless current_admin_user.location
    end

    def save_skipped_id
      if place_id_to_skip = (params[:q][:id_not_eq] rescue nil)
        Skip.find_or_create_by(admin_user: current_admin_user, place_id: place_id_to_skip)
      end
    end

    def place_params
      params.require('place').permit(:data_set_id, :csv_file)
    end

    def scoped_collection
      end_of_association_chain.with_distance_to(current_admin_user.location).with_coordinates
    end

    def parent_or_collection
      params[:data_set_id].present? ? parent.places : Place
    end

  end

  csv do
    column :original_id, humanize_name: false
    column :osm_id, humanize_name: false
    column :osm_type, humanize_name: false
    column :wheelchair, humanize_name: false
    column :wheelchair_toilet, humanize_name: false
    column :ref_url, humanize_name: false
  end

  index title: proc{ I18n.t('places.index.headline', count: parent_or_collection.without_osm_id.with_coordinates.count) }, :default => true, :download_links => false do
    if current_admin_user.email.blank?
      panel I18n.t('places.index.email_nag.headline'), id: 'mail_missing' do
        span "Gib deine"
        span do
          link_to "E-Mail Adresse", edit_admin_account_path(current_admin_user)
        end
        span "an, und wir benachrichtigen Dich über neue POIs in Deiner Nähe."
      end
    end

    h1 I18n.t('welcome.index.sub_headline_1') do
      span link_to(I18n.t('places.index.first.link'), first_path), class: "small"

    end
    selectable_column
    column :name do |place|
      url_for_params = {controller: 'places', action: 'show', data_set_id: params[:data_set_id], id: place.id}
      link_to(place.name, url_for(params.merge(url_for_params)))
    end
    column :address, sortable: :street
    if current_admin_user.admin?
      column :skips_count
    end
    column :distance

    render partial: 'hide_sidebar'

  end

  show title: proc { I18n.t('places.show.headline')} do
    table_options = {
      :id => "index_table_#{active_admin_config.resource_name.plural}",
      :sortable => false,
      :class => "index_table index",
      :i18n => active_admin_config.resource_class
    }

    columns id: "match_view" do
      column span: 2 do

        h2 I18n.t('places.show.headline_source', source: resource.data_set.name)

        table_for [resource], table_options do |t|
          t.column fa_icon("map-marker") do |place|
            span "●", class: :circle
          end
          t.column :name
          t.column :address, :address_with_contact_details
        end

        if mapping = resource.osm_special_phrase
          h2 "#{mapping} in OpenStreetMap"
        else
          h2 I18n.t('places.show.headline_source', source: "OpenStreetMap")
        end

        table_for [], table_options.merge(id: "index_table_candidates") do |t|
          t.column fa_icon("map-marker"), :pos
          t.column :name
          t.column :address, :address_with_contact_details
          t.column "Match?" do |c|
            link_to icon(:check), admin_place_candidate_path(place.id, c.id), class: 'light-button'
          end
        end

        panel I18n.t('places.show.actions'), id: :actions, style: 'padding-bottom: 10px' do
          render partial: "actions", locals: { place: place }
        end

        if current_admin_user.admin?
          render partial: "overrides", locals: { place: place }
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
      f.input :wheelchair, as: :select, collection: ["yes", "no", "limited"], prompt: ''
      f.input :wheelchair_toilet, as: :select, collection: ["yes", "no"], prompt: ''
      f.input :wheelchair_description
      f.input :centralkey
    end
    f.actions
  end
end
