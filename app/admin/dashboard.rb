# encoding: UTF-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    if current_admin_user.email.blank?
      columns do
        column id: "welcome" do
          active_admin_form_for(:account, :url => admin_account_path(current_admin_user), :method => 'PUT') do |f|
            f.inputs "Willkommen bei Poichecker" do
              f.input :email, hint: true
            end
            f.actions do
              f.action :submit
            end
          end
        end
      end
    end
    columns do
      column do
        active_admin_form_for(current_admin_user, :url => upate_address_admin_account_path(current_admin_user), :method => 'PUT', html: { id: "user_address_query_form"}) do |f|
          f.inputs "Wo kennst du dich aus?" do
            f.input :address,
              hint: "Gib eine Adresse ein, an der Du dich gut auskennst.",
              placeholder: "z.B. Unter den Linden 1, 10117 Berlin"
          end
          f.actions do
            f.action :submit, label: "Umgebung speichern"
          end
        end
      end
      column do
        active_admin_form_for(current_admin_user, :url => upate_location_admin_account_path(current_admin_user), :method => 'PUT', html: { id: "user_location_query_form"}) do |f|
          f.inputs "Mein Standort" do
            f.input :lat, input_html: { readonly: true }
            f.input :lon, input_html: { readonly: true }
          end
          f.actions do
            f.action :submit, label: "Locate me", button_html: { class: "locate_me" }
          end
        end
      end
    end
    columns do
      column id: "info" do
        panel "Info" do
          render partial: 'info'
        end
      end
      column id: "checks" do
        panel "Deine letzten Checks" do
          ul do
            current_admin_user.matched_places.each do |place|
              li do
                link_to place.name, admin_data_set_place_path(place.data_set_id, place)
              end
            end
          end
        end
      end
      column id: "comments" do
        panel "Neuste Kommentare" do
          ul do
            render partial: 'active_admin/comments/comment', collection: ActiveAdmin::Comment.all
          end
          link_to "All Kommentare", admin_comments_path
        end
      end
    end
    render partial: 'active_admin/locate_me'
  end # content
end
