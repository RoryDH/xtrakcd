class Schedule < ActiveRecord::Base
  self.inheritance_column = :klass
end
