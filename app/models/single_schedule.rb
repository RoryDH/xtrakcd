class SingleSchedule < Schedule
  typed_store_accessor :settings,
    'comic_number' => :to_i,
    'wday'         => :to_i,
    'hour'         => :to_i,
    'min'          => :to_i
    
  before_create :set_next_send

end
