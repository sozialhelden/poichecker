# encoding: UTF-8
ActiveAdmin.register AdminUser, as: 'Account' do

  actions :edit, :update, :index

  menu if: -> { current_admin_user.admin? }

  permit_params do
    defaults = [:email]

    # Do not allow non admins to set role attribute
    if current_admin_user.admin?
      defaults + [:role_id]
    else
      defaults
    end
  end

  filter :email
  filter :osm_id
  filter :osm_username

  member_action :upate_address, method: :put do
    if data = Geocoder.search(params[:admin_user][:address]).try(:first).try(:data)
      current_admin_user.location = "POINT(#{data['lon']} #{data['lat']})"
      current_admin_user.save!
      redirect_to :back, notice: "Vielen Dank, die Orte wurden deiner Umgebung angepasst."
    else
      redirect_to :back, alert: "Entschuldigung, diese Adresse konnte nicht gefunden werden."
    end
  end

  member_action :upate_location, method: :put do
    current_admin_user.location = "POINT(#{params[:admin_user][:lon]} #{params[:admin_user][:lat]})"
    if current_admin_user.save
      redirect_to :back, notice: "Vielen Dank, die Orte wurden deiner Umgebung angepasst."
    else
      redirect_to :back, alert: "Entschuldigung, diese Adresse konnte nicht gefunden werden."
    end
  end

  controller do
    def redirect_to_edit
      redirect_to edit_admin_account_path(current_admin_user), :flash => flash
    end

    alias_method :show,  :redirect_to_edit
  end

  index :download_links => false do
    column :id
    column :email
    column :osm_id
    column :osm_username
    column :role
    column :location
    column :current_sign_in_at
    default_actions
  end

  form do |f|
    f.inputs I18n.t('activerecord.models.admin_user.one') do
      f.input :email, hint: I18n.t('formtastic.hints.admin_user.email')
      f.input :role if current_admin_user.admin?
      f.input :lat, input_html: {readonly: true}
      f.input :lon, input_html: {readonly: true}
    end
    f.actions do
      f.submit
    end
  end
end