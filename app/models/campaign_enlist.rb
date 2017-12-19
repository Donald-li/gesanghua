# == Schema Information
#
# Table name: campaign_enlists # 活动报名表
#
#  id          :integer          not null, primary key
#  campaign_id :integer                                # 活动ID
#  user_id     :integer                                # 用户ID
#  number      :integer                                # 报名人数
#  remark      :string                                 # 备注
#  total       :decimal(14, 2)   default(0.0)          # 合计报名金额
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CampaignEnlist < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  validates :number, presence: true
  
  default_vaule_for :number, 1

  scope :sorted, ->{ order(created_at: :desc) }

end
