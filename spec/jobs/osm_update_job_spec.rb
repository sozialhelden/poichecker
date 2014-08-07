require 'spec_helper'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/nominatim'
  c.hook_into :webmock # or :fakeweb
end

describe OsmUpdateJob do

  let(:place)         do
    VCR.use_cassette('leipziger_strasse') do
      FactoryGirl.create(:place)
    end
  end
  let(:candidate)     { FactoryGirl.build(:candidate)                             }
  let(:user)          { FactoryGirl.create(:user)                                 }
  let(:changeset)     { Rosemary::Changeset.new(:id => 12345)                     }
  let(:unedited_node) { Rosemary::Node.new(:tags => { 'addr:housenumber' => 10 }) }

  subject { OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, { 'addr:housenumber' => 99 } ) }

  before :each do
    expect(user.id).not_to be_nil
  end

  it "should fail the job when element cannot be found" do
    job = OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, candidate.to_osm_tags )
    api = double(:find_or_create_open_changeset => changeset)
    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).with(candidate.osm_type, candidate.osm_id).and_raise(Rosemary::NotFound.new('NOT FOUND'))

    expect(api).not_to receive(:save)
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 0
    expect(failures).to  eql 1
  end

  it "should fail the job if api is not reachable" do
    job = OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, candidate.to_osm_tags )
    api = double(find_or_create_open_changeset: changeset)
    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).with(candidate.osm_type, candidate.osm_id).and_raise(Rosemary::Unavailable.new('Unavailable'))
    expect(api).not_to receive(:save)
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 0
    expect(failures).to  eql 1

  end

  it "should not update when no changes have been made" do
    job = OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, candidate.to_osm_tags )
    unedited_node = Rosemary::Node.new(candidate.to_osm_attributes)
    api = double(:find_or_create_open_changeset => changeset)
    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).with(candidate.osm_type, candidate.osm_id).and_return(unedited_node)
    expect(api).not_to receive(:save)
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0

  end

  it "should not update lat attribute in updating job" do
    place.lat, place.lon = 45, 10

    # change at least one tag to trigger the save action
    tags = candidate.to_osm_tags
    job = OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, tags.merge({'access' => 'public'}) )

    unedited_node = Rosemary::Node.new(candidate.to_osm_attributes)
    api = double(:find_or_create_open_changeset => changeset)
    expect(Rosemary::Api).to receive(:new).and_return(api)

    expect(api).to receive(:find_element).with(candidate.osm_type, candidate.osm_id).and_return(unedited_node)
    expect(api).to receive(:save) { |node, _| node.lat.should eql 52.0; node.lon.should eql 13.0 }
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0
  end

  it "should not update the node when nothing has been changed" do
    job = OsmUpdateJob.enqueue(candidate.osm_id, candidate.osm_type, user.id, place.id, candidate.to_osm_tags )
    unedited_node = Rosemary::Node.new(candidate.to_osm_attributes)
    api = double(:find_or_create_open_changeset => changeset)

    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).with(candidate.osm_type, candidate.osm_id).and_return(unedited_node)
    expect(api).not_to receive(:save)
    successes, failures = Delayed::Worker.new.work_off

    expect(successes).to eql 1
    expect(failures).to  eql 0
  end

  it "updates the tags" do
    job = OsmUpdateJob.enqueue(1, 'node', user.id, place.id, { 'addr:housenumber' => 99 } )

    api = double(:find_or_create_open_changeset => changeset)

    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).and_return(unedited_node)
    expect(api).to receive(:save) { |node, _| node.tags['addr:housenumber'].should eql 99 }
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0
  end

  it "updates places osm_id, osm_username and place_id" do
    job = OsmUpdateJob.enqueue(1, 'node', user.id, place.id, { 'addr:housenumber' => 99 } )
    api = double(:find_or_create_open_changeset => changeset)
    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).and_return(unedited_node)
    expect(api).to receive(:save) { |node, _| node.tags['addr:housenumber'].should eql 99 }

    expect(Place).to receive(:where).with(id: place.id).and_return(place)
    expect(place).to receive(:update_all).with(osm_id: 1, osm_type: 'node', matcher_id: user.id )

    successes, failures = Delayed::Worker.new.work_off
  end

  it "tries to reuse the users changeset" do
    api = double()

    existing_changeset = Changeset.create(osm_id: 42, admin_user_id: user.id, data_set_id: place.data_set.id)

    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).and_return(unedited_node)

    expect(api).to receive(:find_or_create_open_changeset).with(existing_changeset.osm_id, "Modified via poichecker.de", source: "http://poichecker.de/data_sets/#{place.data_set_id}").and_return(changeset)

    expect(api).to receive(:save) do |node, another_changeset|
      node.tags['addr:housenumber'].should eql 99
      another_changeset.should == changeset
    end
    job = subject
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0

  end

  it "updates the users' changeset id" do
    api = double(:find_or_create_open_changeset => changeset)

    expect(Rosemary::Api).to receive(:new).and_return(api)
    expect(api).to receive(:find_element).and_return(unedited_node)
    expect(api).to receive(:save)

    job = subject
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0

    existing_changesets = Changeset.where(admin_user_id: user.id, data_set_id: place.data_set.id)
    expect(existing_changesets).not_to be_empty
  end

  context "unknown value" do

    let(:wheelchair_node) { Rosemary::Node.new(:tags => { 'addr:housenumber' => 10 }) }

    it "does not update wheelchair tag" do
      wheelchair_node.add_tags( 'wheelchair' => 'yes')
      wheelchair_node.tags["wheelchair"].should eql 'yes'
      job = OsmUpdateJob.enqueue(1, 'node', user.id, place.id, { 'wheelchair' => 'unknown', 'addr:housenumber' => 99 } )

      api = double(:find_or_create_open_changeset => changeset)

      expect(Rosemary::Api).to receive(:new).and_return(api)
      expect(api).to receive(:find_element).and_return(wheelchair_node)
      expect(api).to receive(:save) do |node, _|
        node.tags['wheelchair'].should eql 'yes'
      end
      successes, failures = Delayed::Worker.new.work_off
      expect(successes).to eql 1
      expect(failures).to  eql 0
    end
  end
end
