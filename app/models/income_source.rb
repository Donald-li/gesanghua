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

# 收入来源
class IncomeSource < ApplicationRecord
  has_many :income_records

  has_many :campaign_enlists

  validates :name, presence: true

  enum kind: {weixin: 1, cellphone: 2, computer: 3, offline: 4} # 类型： 1:微信 2:手机 3:PC 4:线下（offline）
  default_value_for :kind, 1

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  def online?
    !self.offline?
  end
end
