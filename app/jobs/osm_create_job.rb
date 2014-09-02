class OsmCreateJob < OsmCommonJob # (:element_id, :element_type, :user_id, :place_id, :tags)

  def self.enqueue(user_id, place_id, tags)

    # Remove wheelchair tag if value is "unknown"
    tags.delete("wheelchair") if tags["wheelchair"] == 'unknown'

    place = Place.find(place_id)
    tags[place.osm_key] = place.osm_value if place.osm_key && place.osm_value

    new(nil, 'node', user_id, place_id, tags).tap do |job|

      # TODO: Do not enqueue Create Jobs for now.
      Skip.find_or_create_by(admin_user_id: user_id, place_id: place_id)
      Delayed::Job.enqueue(job, :queue => 'osm')
    end
  end

  def perform
    osm_element     = Rosemary::Node.new
    osm_element.lat = tags.delete('lat')
    osm_element.lon = tags.delete('lon')
    osm_element.add_tags(tags)
    osm_changeset   = find_or_create_changeset(user, place.data_set_id)
    new_element_id  = api.create(osm_element, osm_changeset)
    place.update_attributes!(osm_id: new_element_id, osm_type: element_type, matcher_id: user_id)
    logger.debug("Newly created element with id: #{new_element_id}")
  end

  def success(job)
  end

  def failure(job)
  end

end
