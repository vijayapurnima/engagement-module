json.extract! lead,
              :id,
              :name,
              :contact,
              :email,
              :phone,
              :comments,
              :created_at
json.user do
json.partial! 'users/user', user: lead.user
end