json.users do
  json.array! @memberships do |membership|
    json.partial! 'users/user', user: membership.user
    json.membership_id membership.id
    json.role membership.role
  end
end