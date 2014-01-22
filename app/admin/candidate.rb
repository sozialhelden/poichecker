# encoding: UTF-8
ActiveAdmin.register Candidate do

  belongs_to :place

  actions :all, :except => [:destroy, :new, :update, :index, :edit, :index]

  permit_params :name, :lat, :lon, :street, :housenumber, :postcode, :city, :website, :phone, :wheelchair

  member_action :merge, :method => :post do
    @candidate = Candidate.new(params[:candidate])

    Delayed::Job.enqueue OsmUpdateJob.new(current_admin_user.id, params[:id], @candidate.attributes)
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
      @candidate ||= Candidate.find(params[:id])
    end

    def parent
      @place ||= Place.find(params[:place_id])
    end
  end

  show title: proc{ parent.name rescue 'Orte' } do
    panel "Vergleich" do
      form_for :candidate, url: merge_place_candidate_path(place.id,resource.id) do |form|
        result = Candidate.new(place.merge_attributes(resource.attributes))
        result.source = "Result"
        attributes_table_for [place, result, resource] do
          %w{source name street housenumber postcode city lat lon wheelchair website phone}.each do |attrib|
            row attrib do |p|
              if attrib == 'source'
                h2 p.source
              else
                if p.id.nil?
                  form.text_field attrib, value: p.send(attrib)
                else
                  link_to(p.send(attrib), "#", class: 'light-button apply', rel: "#candidate_#{attrib}") unless p.send(attrib).blank?
                end
              end
            end
          end
          row :action do |p|
            if p.id.nil?
              form.submit
            else
              span ""
            end
          end
        end
      end
    end
  end
end
