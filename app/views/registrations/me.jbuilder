json.me do
  json.(current_user, :email, :created_at)
  json.favourited do
    json.array!(@favourited_numbers)
  end
end
