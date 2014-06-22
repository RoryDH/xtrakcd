class Comic < ActiveRecord::Base
  def to_param
    number
  end

  def save_by_number
    existing = self.class.where(number: number).first
    if existing
      atts = attributes
      atts.delete("_id")
      existing.update_attributes(atts)
    else
      save
    end
  end

  def set_dimensions
    self.width, self.height = FastImage.size(img_uri)
  end
end
