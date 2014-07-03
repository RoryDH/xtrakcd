class User < ActiveRecord::Base
  MAX_SCHEDULES = 5
  MAX_DESTINATIONS = 3

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favourites
  has_many :favourited, through: :favourites, source: :favable, source_type: 'Comic'
  has_many :schedules
  has_many :destinations

  def favourite_comic(comic)
    unless comic.is_a?(Comic)
      comic = Comic.find_by_number!(comic.to_i)
    end
    favourites.new(favable: comic)
  end

  def has_max_schedules?
    schedules.count >= MAX_SCHEDULES
  end
end
