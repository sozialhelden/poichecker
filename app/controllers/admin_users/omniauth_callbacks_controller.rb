class AdminUsers::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :check_for_valid_permissions, :only => :osm

  def osm
    @admin_user = AdminUser.find_for_osm_oauth(auth_hash, current_admin_user)

    if @admin_user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "OpenStreetMap"
      sign_in_and_redirect @admin_user, :event => :authentication
    else
      session['devise.osm_data'] = auth_hash
      redirect_to after_omniauth_failure_path_for(:admin_user)
    end
  end

  def failure
    set_flash_message :alert, :failure, :kind => 'OpenStreetMap', :reason => (params[:message] || failure_message)
    redirect_to after_omniauth_failure_path_for(:admin_user)
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  WANTED_PERMISSIONS = %w(allow_read_prefs allow_write_api).freeze
  def check_for_valid_permissions
    missing = WANTED_PERMISSIONS - granted_permissions

    if missing.any?
      params[:message] = t('devise.omniauth_callbacks.permission_missing')
      failure
    end
  end

  def granted_permissions
    granted = request.env['omniauth.auth']['info']['permissions'] rescue nil
    granted || []
  end

end