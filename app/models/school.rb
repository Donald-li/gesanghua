# == Schema Information
#
# Table name: schools # 学校表
#
#  id             :integer          not null, primary key
#  name           :string                                 # 学校名称
#  address        :string                                 # 地址
#  approve_state  :integer          default(1)            # 审核状态：1:待审核 2:通过 3:不通过
#  approve_remark :string                                 # 审核备注
#  province       :string                                 # 省
#  city           :string                                 # 市
#  district       :string                                 # 区/县
#  number         :integer                                # 学校人数
#  describe       :string                                 # 学校简介
#  state          :integer          default("enabled")    # 学校状态：1:启用 2:禁用
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class School < ApplicationRecord

  has_many :teachers
  has_many :book_shelves
  has_many :project_applies
  has_many :project_quota

  validates :name, :province, :city, :district, presence: true

  enum state: {enabled: 1, disabled: 2} # 状态：1:启用 2:禁用

  scope :sorted, ->{ order(created_at: :desc) }
end
