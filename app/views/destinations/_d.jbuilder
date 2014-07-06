json.(d, :id, :name, :kind, :created_at, :tested_at)
json.(d, *d.class.stored_attributes[:settings])
