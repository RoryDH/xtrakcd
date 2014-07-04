json.me do
  json.(@me, :id, :email, :created_at)
  json.confirmed(@user.confirmed_at?)
  json.favourited do
    json.array!(@favourited_numbers)
  end
end
