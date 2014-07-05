json.me do
  json.(@me, :id, :email, :created_at)
  json.confirmed(@me.confirmed_at?)
  json.favourited do
    json.array!(@favourited_numbers)
  end
end
