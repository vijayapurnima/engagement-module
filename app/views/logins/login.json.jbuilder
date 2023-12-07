json.user do
  json.partial! 'users/user', user: @user
  json.edo_name @user.service_name
  json.role @user.role
  json.auth_token @data[:data][:token]
  json.group do
    json.partial! 'groups/group', group: @user.group
    json.name @user.service_name
  end
end