class Destination < ActiveRecord::Base
  self.inheritance_column = :klass
  KIND_KLASS = {
    'email'   => EmailDestination,
    'hipchat' => HipchatDestination,
    'slack'   => SlackDestination
  }
  KLASS_KIND = KIND_KLASS.invert
  attr_readonly :klass

  RE_TEST_ATTRS = ['settings']
  before_save :invalidate_tested_if_changed

  belongs_to :user

  validates :user_id, :klass, presence: true
  validates :name, length: { in: 1..100 }
  
  def kind
    KLASS_KIND[self.class]
  end

  def schedules
    Schedule.where("destination_ids @> ?", "{#{id}}")
  end

  def test_success!
    self.tested_at = Time.now
  end

  def invalidate_test!
    self.tested_at = nil
  end

  def needs_retesting?
    (changed & RE_TEST_ATTRS).size > 0
  end

  def invalidate_tested_if_changed
    invalidate_test! if needs_retesting?
  end
end
