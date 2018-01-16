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
#  kind        :integer                                # 类型： 1:线上（online） 2:线下（offline）
#

class IncomeSource < ApplicationRecord
  has_many :income_records

  validates :name, presence: true

  enum kind: {online: 1, offline: 2} # 类型： 1:线上（online） 2:线下（offline）
  default_value_for :kind, 1

  acts_as_list column: :position
  # scope :sorted, ->{ order(created_at: :desc) }
  scope :sorted, ->{ order(position: :asc) }
end
