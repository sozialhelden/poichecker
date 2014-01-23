class OsmUpdateJob < Struct.new(:element_id, :element_type, :tags, :user_id)

  def self.enqueue(element_id, element_type, tags, user_id)

    # Do not enqeue job if not in production or test environment
    return unless Rails.env.production? || Rails.env.test?

    # Remove wheelchair tag if value is "unknown"
    tags.delete("wheelchair") if tags["wheelchair"] == 'unknown'

    new(element_id, element_type, tags, user_id).tap do |job|
      Delayed::Job.enqueue(job)
    end
  end



  def perform
    user = AdminUser.find(user_id)
    client = Rosemary::OauthClient.new(user.access_token)
    raise ArgumentError.new("Client cannot be nil") if client.nil?

    logger.info "OsmUpdateJob -------------------------->"
    logger.info "User: #{user.try(:id)}"

    begin
      element_to_compare = api.find_element(type, element_id)

      element = element_to_compare.dup
      element.tags.merge!(tags)

      # Use spaceship operator for comparision:
      # as "element == element_to_compare" is false because of object_id
      comparison_value = (element_to_compare <=> element)

      # Ignore this job, as there are no changes to be saved
      raise Rosemary::Conflict.new('NotChanged') if comparison_value == 0

      changeset = api.find_or_create_open_changeset(user.changeset_id, "Modified via poichecker.de")
      user.update_attribute(:changeset_id, changeset.id)

      api.save(element, changeset)


    rescue Rosemary::Conflict => conflict
      logger.info "IGNORE: #{type}:#{element_id} nothing has changed!"
      # These changes have already been made, so dismiss this update!
      Airbrake.notify(conflict, :component => 'OsmUpdateJob#perform', :parameters => {:user => user.inspect, :element => element.inspect, :client => client})
    end
  end

  def api
    @api ||= Rosemary::Api.new(client)
  end

  def logger
    Delayed::Worker.logger
  end


end