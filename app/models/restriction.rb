class Restriction < ApplicationRecord
  belongs_to :group

  def get_edo
    result = Rails.cache.fetch("presentation/model/restriction/#{self.id}", expires_in: 1.hours) do
      Edos::GetEdo.call(id: self.group_id)
    end

    if result.success?
      result.edo
    end
  end

end
