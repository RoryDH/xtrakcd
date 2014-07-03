json.(s, :id, :name, :kind, :created_at, :send_count, :destination_ids)
json.active(s.active?)
json.(s, *s.class.stored_attributes[:settings])
