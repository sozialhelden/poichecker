# encoding: UTF-8
ActiveAdmin.register AdminUser, as: 'Account' do

  actions :edit, :update

  permit_params do
    defaults = [:email]

    # Do not allow non admins to set role attribute
    if current_admin_user.admin?
      defaults + [:role]
    else
      defaults
    end
  end

  filter :email
  filter :osm_id
  filter :osm_username

  controller do
    def redirect_to_edit
      redirect_to edit_account_path(current_admin_user), :flash => flash
    end

    alias_method :index, :redirect_to_edit
    alias_method :show,  :redirect_to_edit
  end

  index :download_links => false do
    column :id
    column :email
    column :osm_id
    column :osm_username
    column :role
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