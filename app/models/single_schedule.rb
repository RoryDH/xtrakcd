class ListSchedule < Schedule
  typed_store_accessor :settings,
    'hour'         => :to_i,
    'day'          => :to_i,
    'comic_number' => :to_i
  
end
