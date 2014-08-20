class OsmCommonJob < Struct.new(:element_id, :element_type, :user_id, :place_id, :tags)

  def find_or_create_changeset(user, data_set_id)
    # Find an existing changeset for the user and data_set
    changeset_id = Changeset.where(admin_user_id: user.id, data_set_id: data_set_id).first.try(:osm_id)

    if osm_changeset = api.find_or_create_open_changeset(changeset_id, "Modified via poichecker.de", source: "http://poichecker.de/data_sets/#{data_set_id}")
      cs = Changeset.find_or_initialize_by(admin_user_id: user.id, data_set_id: data_set_id)
      cs.osm_id = osm_changeset.id
      cs.save!
    end
    osm_changeset
  end

  def place
    @place ||= Place.find(place_id)
  end

  def user
    @user ||= AdminUser.find(user_id)
  end

  def client
    @client ||= user.try(:client)
  end

  def api
    @api ||= Rosemary::Api.new(client)
  end

  def logger
    Delayed::Worker.logger
  end

  def before(job)
    logger.debug("Starting job: #{job.id} >>>>>")
    raise ArgumentError.new("Client cannot be nil") if client.nil?
  end

  def error(job,exception)
    logger.error("#{exception.class} #{exception.message}")
    logger.error exception.backtrace.join("\n")
  end

  def after(job)
    logger.debug("Finished job: #{job.id} <<<<<<")
  end

end