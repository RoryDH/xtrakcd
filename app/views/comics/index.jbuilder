json.comics do
  json.array!(@comics) do |c|
    json.(c, :number, :title, :safe_title, :alt_text, :transcript, :date_published, :news, :special_link, :img_url, :viewcount, :width, :height)
  end
end
