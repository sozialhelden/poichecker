# encoding: UTF-8
require 'csv'

class DataSet < ActiveRecord::Base

  validates :license, presence: true
  validates :name, uniqueness: true

  has_many :places

end
