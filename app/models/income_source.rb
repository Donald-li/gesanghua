# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class IncomeSource < ApplicationRecord
  has_many :income_records

  validates :name, presence: true

  scope :sorted, ->{ order(created_at: :desc) }
end
