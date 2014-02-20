# encoding: UTF-8
ActiveAdmin.register AdminUser do

  actions :all, :except => [:create]

  permit_params :email, :osm_id, :osm_username, :role

  filter :email
  filter :osm_id
  filter :osm_username

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
      f.input :email
      f.input :osm_id
      f.input :osm_username
      f.input :role
    end
    f.actions do
      f.submit
    end
  end
end