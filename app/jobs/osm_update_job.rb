class OsmUpdateJob < Struct.new(:user_id, :osm_id, :osm_attributes)

  def perform

    emails.each { |e| NewsletterMailer.deliver_text_to_email(text, e) }
  end
end