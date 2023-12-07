class User < ApplicationRecord
  include AASM
  has_one :edo_membership
  has_many :lead
  has_one :group, through: :edo_membership

  scope :only_active, -> {where(status: 'active', verified: true)}

  scope :by_edo, ->(group_id) {joins(:edo_membership).where('edo_memberships.group_id': group_id)}
  scope :by_admin_role, ->(group_id) {joins(:edo_membership).where('edo_memberships.group_id': group_id,'edo_memberships.role': 'admin')}


  validates :user_type, inclusion: {in: ["admin", "user"]}
  validates :status, inclusion: {in: ["active", "unverified"]}
  validates_uniqueness_of :email, case_sensitive: false


  before_validation :strip_whitespace

  after_save :clear_cache
  after_create :clear_cache
  before_create :modify_sequence


  aasm whiny_transitions: :false, column: 'status' do
    state :unverified, initial: :true
    state :active

    event :activate do
      transitions from: [:unverified], to: :active
    end
  end

  def validate_user_data(group_id)
    errors[:base] << "Name is required" if (self.name.blank?)
    errors[:base] << "Email is required" if (self.email.blank?)
    unless self.email.blank?
      emailDomain = email.scan(/(?<=@)([^\s]+)(?=\s|$)/).first
      email_restriction = Restriction.find_by(group_id: group_id, restriction_type: "email")
      service_name = email_restriction.group.group_details(%w(name))[:name]
      unless email_restriction && emailDomain &&  email_restriction.restrictions.include?(emailDomain[0])
        errors[:base]<<("Email requires valid domain for " + (service_name || ''))
      end
    end
    errors[:base].length > 0 ? (raise ActiveRecord::RecordInvalid.new(self)) : true
  end


  def self.new_simple_code
    # Allow alphanumerics minus a few ambiguous characters
    range = [*("0".."9"), *("A".."Z")] - %w(8 B C D I O 0 Q 1)
    # Select 8 random characters from valid range
    (0..7).map {range.sample}.join
  end


  def verified?
    self.verified == true
  end

  def active?
    self.status == 'active'
  end

  def unverified?
    self.status == 'unverified'
  end

  def admin?
    self.user_type == 'admin'
  end

  def is_user?
    self.user_type == 'user'
  end

  def role
    unless self.edo_membership.nil?
      self.edo_membership.role
    end
  end

  def role_admin?
    self.role == 'admin'
  end

  def membership_id
    unless self.edo_membership.nil?
      self.edo_membership.id
    end
  end

  def group_details(columns)
    Rails.cache.fetch("presentation/model/user/#{self.id}/group_details/columns=#{columns}", expires_in: 1.hours) do
      self.group.group_details(columns)
    end
  end

  def service_name
    group_details(%(name))[:name]
  end

  def code_expired?
    if self.code && self.code_created_at
      self.code_created_at <= (Time.now - 72.hours)
    end
  end

  def verification_link_expired?
    if !self.verified? && self.code && self.code_created_at
      self.code_created_at <= (Time.now - 30.days)
    end
  end

  def group_id
    unless self.group.nil?
      self.group.id
    end
  end

  private

  def clear_cache
    Rails.cache.delete("presentation/model/user/#{self.group_id}")
    Rails.cache.delete("presentation/controllers/users/active/#{self.group_id}")
    Rails.cache.delete("presentation/controllers/users/admins/#{self.group_id}")
    Rails.cache.delete("presentation/controllers/users/all/#{self.group_id}")
    Rails.cache.delete("presentation/model/user/#{self.group_id}")
    Rails.cache.data.keys("presentation/model/user/#{self.id}/group_details/columns=*").each { |key| Rails.cache.delete(key) } if Rails.cache.try(:data)
  end

  def strip_whitespace
    self.email = self.email.try(:strip)
  end

  def modify_sequence
    unless self.id.nil?
      sequence_id = ApplicationRecord.connection.select_value("SELECT setval('users_id_seq', #{self.id}, TRUE)")
    end

  end
end
