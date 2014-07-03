class RandomSchedule < Schedule
  typed_store_accessor :settings,
    'hour'        => :to_i,
    'day'         => :to_i,
    'lower_bound' => :to_i,
    'upper_bound' => :to_i

end
