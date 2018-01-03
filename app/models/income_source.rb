# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id          :integer          not null, primary key
#  name        :string                                 # 名称
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string                                 # 描述
#  position    :integer                                # 位置
#

class IncomeSource < ApplicationRecord
  has_many :income_records

  validates :name, presence: true

  acts_as_list column: :position
  # scope :sorted, ->{ order(created_at: :desc) }
  scope :sorted, ->{ order(position: :asc) }
end
