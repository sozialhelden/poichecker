require 'spec_helper'

describe AdminUser do

  subject do
    FactoryGirl.build(:admin_user)
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :osm_id }
    it { expect(subject).to validate_uniqueness_of :email }
  end

  describe ".display_name" do

    it "uses osm_name as first choice" do
      expect(subject.display_name).to eql 'a_osm_username'
    end

    it "uses email as second choice" do
      subject.osm_username = nil
      expect(subject.display_name).to eql 'tim@example.com'
    end

    it "uses osm_id as last choice" do
      subject.osm_username = nil
      subject.email = nil
      subject.osm_id = 174
      expect(subject.display_name).to eql '174'
    end
  end
end
