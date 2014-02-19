# encoding: UTF-8
# == Schema Information
#
# Table name: data_sets
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  license     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :text
#

require 'csv'

class DataSet < ActiveRecord::Base

  validates :license, :name, presence: true
  validates :name, uniqueness: true

  has_many :places, dependent: :destroy

end
