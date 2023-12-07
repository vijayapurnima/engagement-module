class Lead < ApplicationRecord

  belongs_to :user
  has_one :edo_membership, through: :user


  scope :by_edo, ->(group_id) {joins(:edo_membership).where('edo_memberships.group_id': group_id)}


  CREATE_PARAMS = %w(name contact phone email comments)

  after_create :clear_cache
  after_save :clear_cache

  def validate_lead_data
    errors[:base] << "Lead Name is required" if (self.name.blank?)
    errors[:base] << "Lead Contact is required" if (self.contact.blank?)
    errors[:base] << "Lead Phone Number is required" if (self.phone.blank?)
    errors[:base] << "Lead Email at is required" if ( self.email.blank?)
    errors[:base] << "Lead Comments are required" if (self.comments.blank?)
    errors[:base] << "Lead User is required" if (self.user.blank?)


    errors[:base].length > 0 ? (raise ActiveRecord::RecordInvalid.new(self)) : true
  end



  private

  def clear_cache
    Rails.cache.delete("presentation/controller/leads/index/#{self.user.group_id}")
  end
end
