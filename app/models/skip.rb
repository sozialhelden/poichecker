class Skip < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :place

  validates :place_id, :admin_user_id, presence: true
  validates :admin_user_id, uniqueness: { scope: :place_id }
end
