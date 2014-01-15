class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable,
         :recoverable, :rememberable, :trackable

 validates :email, uniqueness: { allow_nil: true, allow_blank: true }
 validates :osm_id, presence: true

  def self.find_for_osm_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    if admin_user = AdminUser.where(:osm_id => data.id).first
      # found
    else
      admin_user = AdminUser.create!(:osm_id => data.id, :password => Devise.friendly_token[0, 20])
    end
    admin_user.update_attributes(oauth_token: access_token.credentials.token, oauth_secret: access_token.credentials.secret)
    admin_user
  end

  def oauth_authorized?
    !!(oauth_token && oauth_secret)
  end

  def access_token
    if oauth_authorized?
      consumer = OAuth::Consumer.new(OpenStreetMapConfig.oauth_key, OpenStreetMapConfig.oauth_secret, :site => OpenStreetMapConfig.oauth_site)
      access_token = OAuth::AccessToken.new(consumer, oauth_token, oauth_secret)
    end
  end
end
