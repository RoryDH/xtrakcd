class Schedule < ActiveRecord::Base
  self.inheritance_column = :klass
  KIND_KLASS = {
    'random'     => RandomSchedule,
    'latest'     => LatestSchedule,
    'start_from' => StartFromSchedule 
  }
  KLASS_KIND = KIND_KLASS.invert
  attr_readonly :klass

  belongs_to :user
  has_many :outbound_comics

  validates :user_id, :klass, :name, :hour, :min, presence: true
  validates :name, length: { in: 1..100 }
  validate :destination_ids_must_be_valid

  default_scope { where.not(klass: nil) }
  scope :active, -> { where.not(activated_at: nil) }
  scope :due, -> { where('next_send_at < ?', Time.now) }

  before_create :set_next_send

  def kind
    KLASS_KIND[self.class]
  end

  def activate!
    self.activated_at = Time.now unless activated_at
  end

  def deactivate!
    self.activated_at = nil
  end

  def destinations
    Destination.where(id: destination_ids)
  end

  def run_schedule
    comic = get_next_comic # must be defined on subclass
    outbound_comics.create(comic_id: comic.id)
    save if set_next_send
  end

  def calc_next_send # subclasses should override when necessary
    if wday
      Time.now.next_where(wday: wday, hour: hour || 12, min: min || 0)
    elsif hour
      Time.now.next_where(hour: hour, min: min || 0)
    end
  end

  def set_next_send
    self.next_send_at = calc_next_send
  end

  def self.send_all_due
    due = active.due
    due.each { |s| s.run_schedule }
  end

private
  def destination_ids_must_be_valid
    if destination_ids.size > User::MAX_DESTINATIONS
      errors.add(:destination_ids, "max possible is #{User::MAX_DESTINATIONS}.")
    elsif !destination_ids.all? { |e| e.is_a?(Integer) }
      errors.add(:destination_ids, "may only be integer IDs.")
    else
      self.destination_ids = destination_ids.flatten.uniq
      matches = Destination.where(id: destination_ids, user_id: user_id).pluck(:id)

      if destination_ids.size == matches.size
        self.destination_ids = matches
      else
        errors.add(:destination_ids, "don't all exist for current user.")
      end
    end
  end

end
