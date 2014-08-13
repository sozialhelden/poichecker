# == Schema Information
#
# Table name: changesets
#
#  id            :integer          not null, primary key
#  osm_id        :integer          not null
#  admin_user_id :integer          not null
#  data_set_id   :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Changeset do

  subject do
    FactoryGirl.build(:changeset)
  end

  describe "validations" do

    it { expect(subject).to validate_presence_of :admin_user_id }
    it { expect(subject).to validate_presence_of :data_set_id }


    it { expect(subject).to validate_uniqueness_of(:admin_user_id).scoped_to(:data_set_id) }
  end

  describe "associations" do
    it { expect(subject).to belong_to :admin_user }
    it { expect(subject).to belong_to :data_set }
  end


  pending "add some examples to (or delete) #{__FILE__}"
end
