class LatestSchedule < Schedule
  typed_store_accessor :settings,
    'lower_bound' => :to_i,
    'upper_bound' => :to_i,
    'wday'        => :to_i,
    'hour'        => :to_i,
    'min'         => :to_i
    
  before_create :set_next_send

  def calc_next_send
    nil
  end
end
