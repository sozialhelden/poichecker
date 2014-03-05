# encoding: UTF-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    if current_admin_user.email.blank?
      columns do
        column id: "welcome" do
          active_admin_form_for(:account, :url => account_path(current_admin_user), :method => 'PUT') do |f|
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
      column id: "info" do
        panel "Info" do
          para "Hilf der freien Weltkarte OpenStreetMap: Kontrolliere Daten, die das Projekt gespendet bekommt. Das geht ganz leicht und macht sogar Spaß."
        end
      end
      column id: "checks" do
        panel "Deine letzten Checks" do
          ul do
            current_admin_user.matched_places.each do |place|
              li do
                link_to place.name, data_set_place_path(place.data_set_id, place)
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
          link_to "All Kommentare", comments_path
        end
      end

    end
  end # content
end
