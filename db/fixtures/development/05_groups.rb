# frozen_string_literal: true

require 'faker'
SeedFu.quiet = true
puts
print Rainbow('::Groups data').yellow

Group.seed(
  :id,
  {
    id: 1,
    group_id: 1, # this group_id is the id from EcxBusinessService::Groups in Monolith
    group_type: 'edo'
  },
  {
    id: 2,
    group_id: 8, # this group_id is the id from EcxBusinessService::Groups in Monolith
    group_type: 'edo'
  }
)

print '.'
