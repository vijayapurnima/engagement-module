class Group < ApplicationRecord
  has_one :restriction
  has_many :edo_memberships
  has_many :notifications

  # possible values for group_type column are edo and non_edo
  validates :group_type, inclusion: { in: ["edo", "non_edo"] }

  after_save :clear_cache
  after_create :clear_cache

  def self.cached_find group_id
    Rails.cache.fetch("presentation/model/group/cached_find/#{group_id}", expires_in: 1.hours) do
      Group.find(group_id)
    end
  end

  def group_details(columns)
    result = Rails.cache.fetch("presentation/model/group/group_details/#{self.group_id}/columns=#{columns}", expires_in: 1.hours) do
      Groups::GetGroup.call(group_id: self.group_id, columns: columns)
    end
    if result.success?
      result.group
    end
  end

  def clear_cache
    Rails.cache.delete("presentation/model/group/cached_find/#{self.group_id}")
    Rails.cache.data.keys("presentation/model/group/group_details/#{self.group_id}/columns=*").each { |key| Rails.cache.delete(key) } if Rails.cache.try(:data)
    Rails.cache.delete("presentation/interactor/get_edo/group_table_id=#{self.id}")
  end
end