class OsmUpdateJob < OsmCommonJob

  def self.enqueue(element_id, element_type, user_id, place_id, tags)
    # Remove wheelchair tag if value is "unknown"
    tags.delete("wheelchair") if tags["wheelchair"] == 'unknown'

    new(element_id, element_type, user_id, place_id, tags).tap do |job|
      Skip.find_or_create_by(admin_user_id: user_id, place_id: place_id)
      Delayed::Job.enqueue(job, :queue => 'osm')
    end
  end

  def perform
    begin
      osm_element   = update_element(element_type, element_id, tags)
      osm_changeset = find_or_create_changeset(user, place.data_set_id)
      api.save(osm_element, osm_changeset)
      Place.where(id: place_id).update_all({osm_id: element_id, osm_type: element_type, matcher_id: user_id})
    rescue Rosemary::Conflict => e
      # We cannot resolve the conflict from here, so we ignore the job and
      # let another person try to update the osm element later.
      logger.warn "#{e.class} #{e.message}"

      # Update place's osm_id anyways so it is taken from the unmatched list.
      Place.where(id: place_id).update_all({osm_id: element_id, osm_type: element_type, matcher_id: user_id})
    rescue Rosemary::NotFound => e
      # Catch exception and ignore this error.
      # This usually if we try to update elements with live ids on api06.dev server
      logger.warn "#{e.class} #{e.message}"
    end
  end

  def update_element(element_type, element_id, tags)
    element_from_osm = api.find_element(element_type, element_id)

    raise Rosemary::NotFound.new("Cannot find #{element_type} #{element_id}") unless element_from_osm

    element_copy = element_from_osm.dup
    element_copy.tags.merge!(tags)

    # Use spaceship operator for comparision:
    # as "element_copy == element_from_osm" is false because of object_id
    comparison_value = (element_from_osm <=> element_copy)

    # Ignore this job, as there are no changes to be saved
    raise Rosemary::Conflict.new("#{element_type} #{element_id} is the same as the current version in OSM.") if comparison_value == 0
    element_copy
  end

  def success(job)
  end

  def failure(job)
  end

end