json.me do
  json.(@me, :email, :created_at)
  json.favourited do
    json.array!(@favourited_numbers)
  end
end
