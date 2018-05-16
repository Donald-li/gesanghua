class ManagementFeeMonth < ApplicationRecord
  has_many :management_fees, dependent: :restrict_with_error

  enum state: {unaccrue: 0, accrued: 2}
  default_value_for :state, 0

  scope :sorted, ->{ order(id: :desc) }
end
