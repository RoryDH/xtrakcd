class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favourites
  has_many :favourited, through: :favourites, source: :favable, source_type: 'Comic'
  has_many :schedules

  def favourite_comic(comic)
    unless comic.is_a?(Comic)
      comic = Comic.find_by_number!(comic.to_i)
    end
    favourites.new(favable: comic)
  end
end
