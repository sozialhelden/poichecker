# encoding: UTF-8
ActiveAdmin.register ActiveAdmin::Comment, as: 'Comment' do

  filter :body

  index :download_links => false do
    column :resource
    column :author
    column :body
    default_actions if: -> { true } #current_admin_user.admin? }
  end
end
