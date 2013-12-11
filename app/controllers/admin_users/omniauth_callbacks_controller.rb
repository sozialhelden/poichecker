class AdminUsers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def osm
    @admin_user = AdminUser.find_for_osm_oauth(auth_hash, current_admin_user)

    if @admin_user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "OpenStreetMap"
      sign_in_and_redirect @admin_user, :event => :authentication
    else
      session['devise.osm_data'] = auth_hash
      redirect_to new_admin_user_registration_url
    end
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end