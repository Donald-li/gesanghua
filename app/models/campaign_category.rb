# == Schema Information
#
# Table name: campaign_categories # 活动分类表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CampaignCategory < ApplicationRecord

  has_many :campaigns, dependent: :destroy

  validates :name, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

end
