# == Schema Information
#
# Table name: data_sets
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  license    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe DataSet do

  let :data_set do
    FactoryGirl.build(:data_set)
  end

  describe "attributes" do

    it { expect(data_set).to validate_uniqueness_of :name }
    it { expect(data_set).to validate_presence_of   :name }
    it { expect(data_set).to validate_presence_of   :license }


    it "saves attributes" do
      data_set.save!
      expect(data_set).to be_valid
    end
  end

  describe "associations" do
    it { expect(data_set).to have_many(:places).dependent(:destroy) }
  end

end
