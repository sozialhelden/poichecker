# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  osm_id                 :integer
#  oauth_token            :string(255)
#  oauth_secret           :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  osm_username           :string(255)
#  changeset_id           :integer
#  role_id                :integer
#  location               :spatial          point, 4326
#

require 'spec_helper'

describe AdminUser do

  subject do
    FactoryGirl.build(:user)
  end

  describe "validations" do
    it { expect(subject).to validate_presence_of :osm_id }
    it { expect(subject).to validate_uniqueness_of :email }
  end

  describe "associations" do
    it { expect(subject).to have_many :matched_places }
    it { expect(subject).to have_many :changesets }
    it { expect(subject).to belong_to :role }
  end

  describe ".display_name" do

    it "uses osm_name as first choice" do
      expect(subject.display_name).to eql 'a_osm_username (0)'
    end

    it "uses email as second choice" do
      subject.osm_username = nil
      expect(subject.display_name).to eql 'tim@example.com (0)'
    end

    it "uses osm_id as last choice" do
      subject.osm_username = nil
      subject.email = nil
      subject.osm_id = 174
      expect(subject.display_name).to eql '174 (0)'
    end
  end

  describe ".role" do

    it "is not an admin by default" do
      expect(subject.admin?).to be_false
    end
  end

  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }

    describe "for user" do
      let(:user){ FactoryGirl.build(:user) }

      it { expect(subject).to be_able_to(    :read,       Place) }
      it { expect(subject).not_to be_able_to(:write,      Place) }
      it { expect(subject).not_to be_able_to(:upload_csv, Place) }

      it { expect(subject).to be_able_to(    :read,  Candidate) }
      it { expect(subject).not_to be_able_to(:write, Candidate) }

      it { expect(subject).to be_able_to(    :read,  ActiveAdmin::Comment) }
      it { expect(subject).to be_able_to(  :create, ActiveAdmin::Comment) }

    end

    describe "for admin" do
      let(:user){ FactoryGirl.build(:admin) }

      it { expect(subject).to be_able_to(:manage,     :all) }
      it { expect(subject).to be_able_to(:upload_csv, Place) }

    end
  end
end
