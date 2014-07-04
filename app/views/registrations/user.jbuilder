json.me do
  json.(@user, :id, :email, :created_at)
  json.confirmed(@user.confirmed_at?)
end
