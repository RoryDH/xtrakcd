json.(s, :id, :name, :kind, :created_at, :send_count, :destination_ids)
json.active(s.activated_at?)
json.(s, *s.class.stored_attributes[:settings])
