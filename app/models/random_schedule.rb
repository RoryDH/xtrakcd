class RandomSchedule < Schedule
  typed_store_accessor :settings,
    'lower_bound' => :to_i,
    'upper_bound' => :to_i,
    'wday'        => :to_i,
    'hour'        => :to_i,
    'min'         => :to_i

  def get_next_comic
    Comic.random(lower_bound, upper_bound)
  end

end
