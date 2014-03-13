# encoding: UTF-8
require 'delayed_job'
ActiveAdmin.register Candidate do

  belongs_to :place

  actions :all, :except => [:destroy, :update, :edit, :index]

  permit_params :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair, :id, :osm_type

  member_action :merge, :method => :post do
    @candidate = Candidate.new(permitted_params["candidate"])

    current_place = Place.find(params[:place_id])
    OsmUpdateJob.enqueue(params[:id], params[:osm_type], @candidate.to_osm_tags, current_admin_user.id, current_place.id)
    redirect_to admin_next_places_path(q: { dist_greater_than: current_place.distance_to(current_admin_user)}, order: :distance_asc), notice: t('flash.actions.merge.notice', resource_name: @candidate.class.model_name.human)
  end

  controller do

    def new
      @place = Place.find(params[:place_id])
      @candidate = Candidate.new(@place.attributes)
      new!
    end

    def create
      @candidate = Candidate.new(permitted_params["candidate"])
      current_place = Place.find(params[:place_id])
      next_place = current_place.next
      OsmCreateJob.enqueue(@candidate.attributes, current_admin_user.id, current_place.id) if @candidate.valid? # success
      next_url = next_place ? admin_data_set_place_path(current_place.data_set_id, next_place) : data_set_path(current_place.data_set_id)
      create! { next_url }
    end

    private

    def resource
      @candidate = Candidate.find(params[:id], params[:osm_type]) if params[:id]
      @candidate ||= Candidate.new(@place.attributes)
    end

    def parent
      @place = Place.find(params[:place_id])
    end

    def begin_of_association_chain
      @place = Place.find(params[:place_id])
    end

  end

  form partial: 'admin/candidates/new'

  show title: proc{ parent.name rescue 'Orte' } do
    columns do
      column do
        panel "Quelle: Datenspende" do
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
          form_for candidate, url: merge_place_candidate_path(place.id,resource.id) do |form|
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
                form.submit "Speichern in OpenStreetMap"
              end
            end
          end
        end
      end

      column do
        panel "Quelle: OpenStreetMap" do
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
