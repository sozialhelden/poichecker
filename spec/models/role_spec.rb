# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Role do

  subject do
    FactoryGirl.build(:role)
  end

  describe "associations" do
    it { expect(subject).to have_many :admin_users }
  end
end
