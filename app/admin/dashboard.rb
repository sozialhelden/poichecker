# encoding: UTF-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    if current_admin_user.email.blank?
      columns do
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
        column do
          panel "Info" do
            para "Hilf der freien Weltkarte OpenStreetMap: Kontrolliere Daten, die das Projekt gespendet bekommt. Das geht ganz leicht und macht sogar Spaß."
          end
        end
      end
    end
  end # content
end
