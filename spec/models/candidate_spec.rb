require 'spec_helper'
require 'vcr'


describe Candidate do

  before :each do
    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/overpass'
      c.hook_into :webmock # or :fakeweb
    end
  end

  subject do
    FactoryGirl.build(:candidate)
  end

  describe "attributes" do
    it { expect(subject).to validate_presence_of :lat }
    it { expect(subject).to validate_presence_of :lon }
  end

  describe ".to_osm_attributes" do

    it "does not contain blank or nil values" do
      tag_values = subject.to_osm_tags.values
      expect(tag_values).not_to include(nil)
    end
  end

  describe "overpass" do

    it "finds a node via Overpass API" do
      VCR.use_cassette('a_node') do
        candidate_node = Candidate.find(333537503, 'node')
        expect(candidate_node.lat).to eql 52.5179427
        expect(candidate_node.lon).to eql 13.397522
      end
    end

    it "find an invalid node via Overpass API" do
      VCR.use_cassette('no_node') do
        no_candidate = Candidate.find(1234, 'node')
        expect(no_candidate).to be_nil
      end
    end

    it "finds a way via Overpass API" do
      VCR.use_cassette('a_way') do
        candidate_way = Candidate.find(15971186, 'way')
        expect(candidate_way.name).to eql 'Zeughaus'
        expect(candidate_way.lat).to eql 52.5180903
        expect(candidate_way.lon).to eql 13.396975300000001
      end
    end

    it "find an invalid way via Overpass API" do
      VCR.use_cassette('no_way') do
        no_candidate = Candidate.find(1234, 'way')
        expect(no_candidate).to be_nil
      end
    end
  end
end