class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favable, polymorphic: true

  validates :favable_id, uniqueness: {
    scope: [:user_id, :favable_type],
    message: 'You may only favourite once'
  }
  validates :favable_type, inclusion: { in: ['Comic'] }
end
