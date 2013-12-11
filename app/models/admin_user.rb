class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable,
         :recoverable, :rememberable, :trackable

 validates :email, uniqueness: true

  def self.find_for_osm_oauth(access_token, signed_in_resource=nil)
     data = access_token.info
     if admin_user = AdminUser.where(:osm_id => data.id).first
       admin_user
     else
       AdminUser.create!(:osm_id => data.id, :password => Devise.friendly_token[0, 20])
     end
   end
end
