ActiveAdmin.register Node do

  menu :label => proc{ "Orte" }
  permit_params :data_set_id, :original_id, :osm_id, :name, :lat, :lon, :street, :housenumber, :postcode, :city, :country, :website, :phone, :wheelchair

  belongs_to :data_set, optional: true

  actions :all, :except => [:destroy]
  config.batch_actions = false

  controller do

    def show
      @nodes = Node.where(:id => params[:id]).page(params[:page]).per(10)
      render action: :index
    end
  end

  index title: 'Orte' do
    selectable_column
    column "Koordinaten" do |node|
      if node.lat && node.lon
        link_to "#{node.lat || 0.0},#{node.lon || 0.0}", "http://www.openstreetmap.org/#map=17/#{node.lat}/#{node.lon}", target: '_blank'
      else
        span "fehlt"
      end
    end
    column :name
    column :full_address, sortable: :street
    column :osm_tag do |node|
      if node.osm_key && node.osm_value
        link_to"#{node.osm_key} => #{node.osm_value}","http://wiki.openstreetmap.org/wiki/Tag:#{node.osm_key}%3D#{node.osm_value}"
      else
        span "fehlt"
      end
    end
    column :website
    column :phone
    column :wheelchair do |node|
      status_tag(node.wheelchair, :class => node.wheelchair)
    end

    default_actions
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
