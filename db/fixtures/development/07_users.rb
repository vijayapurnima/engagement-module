# frozen_string_literal: true

require 'faker'
SeedFu.quiet = true
puts
print Rainbow('::Users data').yellow

User.seed(
  :id,
  {
    id: 1,
    email: 'edoadmin@tsbe.com.au',
    name: 'EdoAdmin',
    verified: true,
    code: nil,
    code_created_at: nil,
    status: 'active',
    user_type: 'user'

  },
  {
    id: 2,
    email: 'edoadmin2@h2q.org.au',
    name: 'EdoAdmin2',
    verified: true,
    code: nil,
    code_created_at: nil,
    status: 'active',
    user_type: 'user'
  }
)

print '.'

puts
print Rainbow('::EdoMemberships data').yellow
EdoMembership.seed(
  :id,
  {
    id: 1,
    user_id: 1,
    role: 'admin',
    group_id: 1

  },
  {
    id: 2,
    user_id: 2,
    role: 'admin',
    group_id: 2
  }
)

print '.'
puts
