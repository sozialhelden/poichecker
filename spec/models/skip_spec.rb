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

require 'spec_helper'

describe Skip do

  describe "associations" do
    it { expect(subject).to belong_to(:place) }
    it { expect(subject).to belong_to(:admin_user) }
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :admin_user_id }
    it { expect(subject).to validate_presence_of :place_id }
    it { expect(subject).to validate_uniqueness_of(:admin_user_id).scoped_to(:place_id) }
  end

end
