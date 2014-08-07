# == Schema Information
#
# Table name: changesets
#
#  osm_id        :integer          not null
#  admin_user_id :integer          not null
#  data_set_id   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Changeset < ActiveRecord::Base
  belongs_to :admin_user
  belongs_to :data_set

  validates :admin_user_id, :data_set_id, presence: true
  validates :admin_user_id, uniqueness: { scope: :data_set_id }
end
