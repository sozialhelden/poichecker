# == Schema Information
#
# Table name: skips
#
#  id            :integer          not null, primary key
#  admin_user_id :integer          not null
#  place_id      :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Skip < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :place

  validates :place_id, :admin_user_id, presence: true
  validates :admin_user_id, uniqueness: { scope: :place_id }
end
