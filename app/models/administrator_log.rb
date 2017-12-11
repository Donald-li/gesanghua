class AdministratorLog < ApplicationRecord
  belongs_to :administrator

  scope :sorted, -> { order(created_at: :desc) }
end
