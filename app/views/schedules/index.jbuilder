json.schedules do 
  json.array! @schedules, partial: 's', as: :s
end
