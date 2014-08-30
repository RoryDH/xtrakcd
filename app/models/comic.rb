class Comic < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => [:title, :alt_text, :transcript]

  has_many :favourites, as: :favable, dependent: :destroy
  has_many :favourited_by, through: :favourites, source: :user

  def to_param
    number.to_i
  end

  def set_dimensions
    self.width, self.height = FastImage.size(img_uri)
  end

  def self.random(lower = 1, upper = latest.number)
    n = rand(upper)
    find_by_number!(n)
  end

  def self.latest
    order(number: :desc).first
  end

  def self.save_by_number(comic_hash)
    existing = find_by_number(comic_hash[:number])
    if existing
      existing.update_attributes(comic_hash)
    else
      create(comic_hash)
    end
  end
end
