class EdoMembership < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :invited_by, class_name: 'User', optional: true

  scope :by_edo, ->(group_id) {where('edo_memberships.group_id': group_id)}


end
