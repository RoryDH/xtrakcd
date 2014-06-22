class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :favourites
  has_many :favourited, through: :favourites, source: :favable, source_type: "Comic"

  def favourite_comic(comic)
    favourites.create(comic: comic)
  end
end
