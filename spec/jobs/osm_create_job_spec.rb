require 'spec_helper'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/nominatim'
  c.hook_into :webmock # or :fakeweb
end

describe OsmCreateJob do

  let(:place)         do
    VCR.use_cassette('leipziger_strasse') do
      FactoryGirl.create(:place)
    end
  end
  let(:user)          { FactoryGirl.create(:user)                                 }
  let(:changeset)     { Rosemary::Changeset.new(:id => 12345)                     }

  subject { OsmCreateJob.enqueue(user.id, place.id, { 'addr:housenumber' => 99, 'lat' => 52.4, 'lon' => 13.0 } ) }

  before :each do
    expect(user.id).not_to be_nil
  end

  it "should create a Node" do
    api = double(:find_or_create_open_changeset => changeset)

    Rosemary::Api.should_receive(:new).and_return(api)
    api.should_receive(:create) do |node, _|
      node.lat.should eql 52.4
      node.lon.should eql 13.0
      node.tags['addr:housenumber'].should eq 99
    end
    job = subject
    successes, failures = Delayed::Worker.new.work_off
    successes.should eql 1
    failures.should eql 0
  end

  it "tries to find a changeset for the user" do
    Rosemary::Api.should_receive(:new).and_return(api = double())

    api.should_receive(:find_or_create_open_changeset).with(user.changeset_id, anything()).and_return(changeset)
    api.should_receive(:create).with(anything(), changeset)

    job = subject
    successes, failures = Delayed::Worker.new.work_off
    successes.should eql 1
    failures.should eql 0
  end

  it "updates the users' changeset id" do
    api = double(:find_or_create_open_changeset => changeset)

    expect(Rosemary::Api).to receive(:new).and_return(api)
    api.should_receive(:create).with(anything(), changeset)

    job = subject
    successes, failures = Delayed::Worker.new.work_off
    expect(successes).to eql 1
    expect(failures).to  eql 0

    existing_changesets = Changeset.where(admin_user_id: user.id, data_set_id: place.data_set.id)
    expect(existing_changesets).not_to be_empty
  end

end
