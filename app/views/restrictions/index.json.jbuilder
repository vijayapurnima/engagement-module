json.array!(@restrictions) do |restriction|
  json.partial! 'edos/edo', edo: restriction.get_edo
end