class RandomSchedule < Schedule
  store_accessor :settings,
                 :hour,
                 :day,
                 :lower_bound,
                 :upper_bound
end
