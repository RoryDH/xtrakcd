class OutboundComic < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :comic

  scope :to_be_sent, -> { where(sent_at: nil) }

  def send_to_destinations
    destinations = schedule.destinations
    successful_destinations = []
    destinations.each do |dest|
      dest.deliver(comic)
      successful_destinations << dest
    end
    self.destination_ids = successful_destinations
    self.sent_at = Time.now
    save
  end

  def self.send_all
    to_be_sent.includes(:schedule, :comic).each(&:send_to_destinations)
  end
end
