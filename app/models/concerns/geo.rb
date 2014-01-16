require 'rgeo'

module Geo
  extend ActiveSupport::Concern
  included do

    attr_accessor :bbox, :factory

    def factory
      @factory ||=  RGeo::Cartesian.factory
    end

    def bbox
      @bbox ||= RGeo::Cartesian::BoundingBox.new(factory)
    end

    def to_bbox
      # return bbox unless bbox.nil?
      center = factory.point(lon, lat)
      bbox.add(center)
      widen_by_meters
      bbox
    end

    def widen_by_meters(meters=1000)
      south_west = factory.point(self.lon - degrees_per_meter_longitude(meters/2) , self.lat - degrees_per_meter_latitude(meters/2))
      north_east = factory.point(self.lon + degrees_per_meter_longitude(meters/2) , self.lat + degrees_per_meter_latitude(meters/2))
      bbox.add(south_west)
      bbox.add(north_east)
    end

    def distance_to(other_place)
      factory.point(lon,lat).distance(factory.point(other_place.lon,other_place.lat)).abs
    end

    def meters_per_degrees_latitude
      111132.92 - (559.82 * Math.cos(2 * self.lat)) + (1.175 * Math.cos(4 * self.lat))
    end

    def meters_per_degrees_longitude
      111412.84 * Math.cos(self.lat) - 93.5 * Math.cos(3 * self.lat)
    end

    def degrees_per_meter_latitude(meters = 1)
      meters / meters_per_degrees_latitude
    end

    def degrees_per_meter_longitude(meters = 1)
      meters / meters_per_degrees_longitude
    end

    def w
      to_bbox.min_x
    end

    def e
      to_bbox.max_x
    end

    def n
      to_bbox.max_y
    end

    def s
      to_bbox.min_y
    end

  end
end