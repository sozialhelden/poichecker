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

  action_item only: :edit  do
    link_to edit_location_admin_account_path(current_admin_user) do
      fa_icon('dot-circle-o', text: I18n.t('header.action_items.edit_location'))
    end

  end

  member_action :update_location, method: :put do
    if params[:admin_user][:use_location] == '1'
      current_admin_user.location = "POINT(#{params[:admin_user][:lon]} #{params[:admin_user][:lat]})"
      current_admin_user.save!
      redirect_to edit_location_admin_account_path(current_admin_user), notice: I18n.t('flash.actions.location_missing.notice')
    else
      if params[:admin_user][:address].blank?
        redirect_to edit_location_admin_account_path(current_admin_user), alert: I18n.t('flash.actions.address_missing.alert')
        return
      end
      if data = Geocoder.search(params[:admin_user][:address]).try(:first).try(:data)
        current_admin_user.location = "POINT(#{data['lon']} #{data['lat']})"
        current_admin_user.save!
        redirect_to edit_location_admin_account_path(current_admin_user), notice: I18n.t('flash.actions.location_missing.notice')
      else
        redirect_to edit_location_admin_account_path(current_admin_user), alert: I18n.t('flash.actions.address_missing.not_found')
      end
    end
  end

  member_action :edit_location, method: :get do
    @page_title = I18n.t('accounts.edit_location.headline', locale: I18n.locale)
  end

  controller do

    before_filter :set_locale

    def redirect_to_edit
      redirect_to edit_admin_account_path(current_admin_user), :flash => flash
    end

    alias_method :show,  :redirect_to_edit

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options(options={})
      { :locale => I18n.locale }
    end


  end

  index :download_links => false do
    column :id
    column :email
    column :osm_id
    column :osm_username do |user|
      link_to_if user.osm_username, user.osm_username, "http://www.openstreetmap.org/user/#{user.osm_username}"
    end
    column :role
    column :location
    column :current_sign_in_at
    default_actions
  end

  form do |f|
    f.inputs I18n.t('activerecord.models.admin_user.one') do
      f.input :email, hint: I18n.t('formtastic.hints.admin_user.email')
      f.input :role if current_admin_user.admin?
    end
    f.actions do
      f.submit
    end
  end
end