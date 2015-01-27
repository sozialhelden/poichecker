# encoding: UTF-8
require 'delayed_job'
include ApplicationHelper
ActiveAdmin.register Candidate do

  belongs_to :place

  actions :all, :except => [:destroy, :update, :edit, :index]

  permit_params :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair, :id, :osm_type

  member_action :merge, :method => :post do
    @candidate = Candidate.new(permitted_params["candidate"])

    current_place = Place.find(params[:place_id])
    OsmUpdateJob.enqueue(params[:id], params[:candidate][:osm_type], current_admin_user.id, current_place.id, @candidate.to_osm_tags)

    redirect_to next_path(current_admin_user, current_place), notice: t('flash.actions.merge.notice', resource_name: @candidate.class.model_name.human)
  end

  collection_action :suggest, method: :get do
    bbox = parent.to_bbox(1000)
    # bottom, left, top, right
    candidates = Candidate.search(parent.name, bbox.min_y, bbox.min_x, bbox.max_y, bbox.max_x, parent.osm_key, parent.osm_value, ['node', 'way'])
    p = parent
    candidates.sort! { |x, y| x.distance_to(p) <=> y.distance_to(p) }
    render json: candidates[0...9].to_json
  end

  controller do

    def new
      @place = Place.find(params[:place_id])
      params["candidate"] = @place.attributes
      @candidate = Candidate.new(permitted_params["candidate"])
      new!
    end

    def create
      if current_admin_user.admin?
        @candidate = Candidate.new(permitted_params["candidate"])
        current_place = Place.find(params[:place_id])
        OsmCreateJob.enqueue(current_admin_user.id, current_place.id, @candidate.attributes) if @candidate.valid? # success
        create! { next_path(current_admin_user, current_place) }
      else
        redirect_to next_path(current_admin_user, current_place)
      end
    end

    private

    def resource
      @candidate ||= Candidate.find(params[:id], params[:osm_type] || 'node') if params[:id]
      if @candidate.nil?
        params["candidate"] = parent.attributes
        @candidate = Candidate.new(permitted_params["candidate"])
      end
      @candidate
    end

    def parent
      @place = Place.find(params[:place_id])
    end

    def begin_of_association_chain
      @place = Place.find(params[:place_id])
    end

  end

  form partial: 'admin/candidates/new'

  show title: :name do
    columns do
      column do
        panel I18n.t('places.show.headline_source', source: place.data_set.name) do
          form_for :source, url: '/', disabled: true do |form|
            attributes_table_for place do
              %w{name street housenumber postcode city wheelchair website phone}.each do |attrib|
                row attrib, class: "single left-source" do |p|
                  #image_tag "http://api.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/pin-l-star+A22(#{place.lon},#{place.lat})/#{place.lon},#{place.lat},17/480x320.png64", style: "width:100%"
                  render partial: "left_form_field", locals: { form: form, attrib: attrib, value: p.send(attrib) }
                end
              end
            end
          end
        end
      end

      column do
        panel "Ergebnis" do
          form_for candidate, url: merge_admin_place_candidate_path(place.id,resource.id) do |form|
            result = Candidate.new(resource.merge_attributes(place.attributes))
            form.hidden_field :osm_type, value: params[:osm_type]
            attributes_table_for result do
              Candidate.valid_keys.reject{|a| a == :id}.each do |attrib|
                next if attrib == :lat || attrib == :lon
                row attrib do |p|
                  #image_tag "http://api.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/#{result.lon},#{result.lat},17/480x320.png64", style: "width:100%"
                  form.text_field attrib, value: p.send(attrib), label: true, class: [(place.send(attrib) != resource.send(attrib) ? 'different' : 'same'),p.send(attrib).blank? ? 'blank' : nil, resource.send(attrib).blank? ? 'new' : nil, place.send(attrib).blank? ? 'old' : nil]
                end
              end
              row :action do |p|
                form.submit I18n.t('formtastic.actions.candidate.create')
              end
            end
          end
        end
      end

      column do
        panel I18n.t('places.show.headline_source', source: 'OpenStreetMap') do
          form_for :source, url: '/', disabled: true do |form|
            attributes_table_for resource do
              %w{name street housenumber postcode city wheelchair website phone}.each do |attrib|
                row attrib, class: "single right-source" do |p|
                  #image_tag "http://api.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/pin-l-star+2A2(#{resource.lon},#{resource.lat})/#{resource.lon},#{resource.lat},17/480x320.png64", style: "width:100%"
                  render partial: "right_form_field", locals: { form: form, attrib: attrib, value: p.send(attrib) }
                end
              end
            end
          end
        end
      end

    end
  end
end
