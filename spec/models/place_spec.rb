# == Schema Information
#
# Table name: places
#
#  id          :integer          not null, primary key
#  data_set_id :integer
#  original_id :integer
#  osm_id      :integer
#  name        :string(255)
#  lat         :float
#  lon         :float
#  street      :string(255)
#  housenumber :string(255)
#  postcode    :string(255)
#  city        :string(255)
#  country     :string(255)
#  website     :string(255)
#  phone       :string(255)
#  wheelchair  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  osm_type    :string(255)
#  matcher_id  :integer
#

require 'spec_helper'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/nominatim'
  c.hook_into :webmock # or :fakeweb
end

describe Place do

  subject do
    FactoryGirl.build(:place)
  end

  describe "validations" do

    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :data_set_id }

    it "saves attributes" do
      VCR.use_cassette('leipziger_strasse') do
        subject.save!
      end
      expect(subject).to be_valid
    end
  end

  describe "associations" do
    it { expect(subject).to belong_to :data_set }
    it { expect(subject).to belong_to :matcher }
  end

  describe "address methods" do

    it "assembles street info from street and housenumber" do
      subject.street = 'a_street'
      subject.housenumber = 'a_housenumber'
      expect(subject.street_info).to eql ['a_street', 'a_housenumber']
    end

    it "assemles city info from city and postcode" do
      subject.city = 'a_city'
      subject.postcode = 'a_postcode'
      expect(subject.city_info).to eql ['a_postcode', 'a_city']

    end
  end

  describe "geocode" do

    it "defines a set of attributes that belong to a address" do
      expect(subject.address_keys).to eql %w{street housenumber city postcode country}
    end

    it "detects that address has been changed when street changed" do
      subject.street = 'some_street'
      expect(subject.address_changed?).to be_true
    end

    it "detects that address has been changed when housenumber changed" do
      subject.housenumber = 'some_housenumber'
      expect(subject.address_changed?).to be_true
    end

    it "detects that address has been changed when city changed" do
      subject.city = 'some_city'
      expect(subject.address_changed?).to be_true
    end

    it "detects that address has been changed when postcode changed" do
      subject.postcode = 'some_postcode'
      expect(subject.address_changed?).to be_true
    end

    it "detects that address has been changed when country changed" do
      subject.country = 'some_country'
      expect(subject.address_changed?).to be_true
    end

    it "re-geocodes lat/lon after address changes" do
      VCR.use_cassette('leipziger_strasse') do
        subject.street      = 'Leipziger Strasse'
        subject.housenumber = '65'
        subject.city        = 'Berlin'
        subject.postcode    = '10117'
        subject.save!
        expect(subject.lat).to eql 52.5112595
        expect(subject.lon).to eql 13.3933457
      end
    end

  end

end
