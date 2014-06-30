class Comic < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, :against => [:title, :alt_text, :transcript]

  has_many :favourites, as: :favable, dependent: :destroy
  has_many :favourited_by, through: :favourites, source: :user

  def to_param
    number.to_i
  end

  def save_by_number
    existing = self.class.where(number: number).first
    if existing
      atts = attributes
      existing.update_attributes(atts)
    else
      save
    end
  end

  def set_dimensions
    self.width, self.height = FastImage.size(img_uri)
  end

  def self.random(upper, lower)
    find_by_number!(rand(upper..lower))
  end
end
