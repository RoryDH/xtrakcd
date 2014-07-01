class Schedule < ActiveRecord::Base
  self.inheritance_column = :klass

  belongs_to :user
end
