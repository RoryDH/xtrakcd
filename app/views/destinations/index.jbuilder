json.destinations do
  json.array! @dests, partial: 'd', as: :d
end
