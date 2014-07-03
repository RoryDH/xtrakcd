class Destination < ActiveRecord::Base
  self.inheritance_column = :klass

  store_accessor :settings, :url
end
