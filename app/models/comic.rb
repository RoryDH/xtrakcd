class Comic < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: {
    title: 'A',
    alt_text: 'B',
    transcript: 'C'
  }, using: { tsearch: { dictionary: "english" } }

  has_many :favourites, as: :favable, dependent: :destroy
  has_many :favourited_by, through: :favourites, source: :user

  max_paginates_per 50

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

  def self.order_with_defaults(attribute, direction)
    attribute = 'number' unless column_names.include?(attribute)
    direction = 'asc' unless %w(asc desc).include?(direction)
    order(attribute.to_sym => direction.to_sym)
  end
end
