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
#  level          :integer                                # 学校等级： 1:初中 2:高中
#  contact_name   :string                                 # 联系人
#  contact_phone  :string                                 # 联系方式
#

class School < ApplicationRecord

  has_many :teachers
  has_many :book_shelves
  has_many :project_season_applies

  validates :name, :province, :city, :district, presence: true

  enum state: {enabled: 1, disabled: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum level: {junior: 1, senior: 2} # 学校等级：1:初中 2:高中
  default_value_for :level, 1

  scope :sorted, ->{ order(created_at: :desc) }


  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end

end
