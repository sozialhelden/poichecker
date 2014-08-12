# encoding: UTF-8
ActiveAdmin.register DataSet do
  decorate_with DataSetDecorator

   menu false

  config.batch_actions = false

  permit_params :name, :license, :description


  action_item  if: -> { can?(:upload_csv, Place) }  do
    link_to upload_csv_admin_places_path do
      fa_icon('upload', text: 'Upload CSV')
    end
  end

  filter :name
  filter :license,      if: ->(data_set) { current_admin_user.admin? }
  filter :description,  if: ->(data_set) { current_admin_user.admin? }
  filter :created_at,   if: ->(data_set) { current_admin_user.admin? }

  index :download_links => false do
    selectable_column if current_admin_user.admin?
    column :id if current_admin_user.admin?
    column :name
    column :license
    column :orte
    column 'Gespendet am', :created_at
    default_actions if current_admin_user.admin?

  end
end
