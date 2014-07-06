class HipchatDestination < Destination
  typed_store_accessor :settings,
    'api_key'     => nil,
    'room'        => nil

  validates :api_key, length: { is: 40 }
  validates :room, length: { in: 1..100 }

  # def send(message)
    
  # end
end
