# frozen_string_literal: true

require 'faker'
SeedFu.quiet = true
puts
print Rainbow('::Restrictions data').yellow

Restriction.seed(
  :id,
  {
    id: 1,
    group_id: 1,
    restriction_type: 'email',
    restrictions: ['tsbe.com.au']
  },
  {
    id: 2,
    group_id: 2,
    restriction_type: 'email',
    restrictions: ['@h2q.org.au']
  }
)

print '.'
