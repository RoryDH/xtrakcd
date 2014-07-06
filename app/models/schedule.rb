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

  validates :user_id, :klass, :name, presence: true
  validates :name, length: { in: 1..100 }
  validate :destination_ids_must_be_valid

  default_scope { where.not(klass: nil) }
  scope :active, -> { where.not(active: nil) }

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

private
  def destination_ids_must_be_valid
    if destination_ids.size > User::MAX_DESTINATIONS
      errors.add(:destination_ids, "max possible is #{User::MAX_DESTINATIONS}.")
    elsif !destination_ids.all? { |e| e.is_a?(Integer) }
      errors.add(:destination_ids, "may only be integer IDs.")
    else
      self.destination_ids = destination_ids.flatten.uniq
      matches = user.destinations.where(id: destination_ids).pluck(:id)

      if destination_ids.size == matches.size
        self.destination_ids = matches
      else
        errors.add(:destination_ids, "don't all exist for current user.")
      end
    end
  end

end
