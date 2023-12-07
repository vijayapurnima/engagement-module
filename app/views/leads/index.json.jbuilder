json.array!(@leads) do |lead|
  json.partial! 'leads/lead', lead: lead
end