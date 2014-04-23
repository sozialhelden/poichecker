class OsmCreateJob < Struct.new(:tags, :user_id, :place_id)

  def self.enqueue(tags, user_id, place_id)
    # Do not enqeue job if not in production or test environment
    return unless Rails.env.production? || Rails.env.test?

    # Remove wheelchair tag if value is "unknown"
    tags.delete("wheelchair") if tags["wheelchair"] == 'unknown'

    new('node', tags, user_id, place_id).tap do |job|
      Delayed::Job.enqueue(job)
    end
  end



  def perform
    # create node on osm and save resulting node_id to the place_id
    # current_place.update_attributes(osm_id: element_id, osm_type: :node, matcher_id: user_id)
  end

  def success(job)
    logger.debug("Hoooray, success!")
    # TODO: Update place with newly created osm id
  end
end
