# encoding: UTF-8
require 'delayed_job'
ActiveAdmin.register Candidate do

  belongs_to :place

  actions :all, :except => [:destroy, :new, :update, :index, :edit, :index]

  permit_params :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair

  member_action :merge, :method => :post do
    @candidate = Candidate.new(params[:candidate])

    OsmUpdateJob.enqueue(params[:id], 'node', @candidate.attributes, current_admin_user.id)
    current_place = Place.find(params[:place_id])
    if next_place = current_place.next
      redirect_to data_set_place_path(current_place.data_set_id, next_place)
    else
      redirect_to data_set_path(current_place.data_set_id)
    end
  end

  controller do

    private

    def resource
      @candidate ||= Candidate.find(params[:id], params[:osm_type])
    end

    def parent
      @place ||= Place.find(params[:place_id])
    end
  end

  show title: proc{ parent.name rescue 'Orte' } do
    columns do
      column do
        panel "Quelle: Datenspende" do
          form_for :source, url: '/', disabled: true do |form|
            attributes_table_for place do
              %w{name street housenumber postcode city wheelchair website phone lat lon}.each do |attrib|
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
          form_for :candidate, url: merge_place_candidate_path(place.id,resource.id) do |form|
            result = Candidate.new(resource.merge_attributes(place.attributes))

            attributes_table_for result do
              result.valid_keys.reject{|a| a == :id}.each do |attrib|
                row attrib do |p|
                  #image_tag "http://api.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/#{result.lon},#{result.lat},17/480x320.png64", style: "width:100%"
                  form.text_field attrib, value: p.send(attrib), label: true
                end
              end
              row :action do |p|
                form.submit
              end
            end
          end
        end
      end

      column do
        panel "Quelle: OpenStreetMap" do
          form_for :source, url: '/', disabled: true do |form|
            attributes_table_for resource do
              %w{name street housenumber postcode city wheelchair website phone lat lon}.each do |attrib|
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
