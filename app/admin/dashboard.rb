# encoding: UTF-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      if current_admin_user.email.blank?
        column do
          active_admin_form_for(current_admin_user, :as => :admin_user, :url => admin_user_path(current_admin_user)) do |f|
            f.inputs "Willkommen bei Poichecker" do
              f.input :email, hint: "Damit informieren wir Dich über neue Datenspenden, die Deine Hilfe brauchen. Wir behandeln Deine Adresse vertraulich, kein Spam, versprochen."
            end
            f.actions do
              f.submit "Update"
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Info" do
          para "Hilf der freien Weltkarte OpenStreetMap: Kontrolliere Daten, die das Projekt gespendet bekommt. Das geht ganz leicht und macht sogar Spaß."
        end
      end
      column do
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
      column do
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
