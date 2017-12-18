# == Schema Information
#
# Table name: goods_project_apply_items # 物资类项目申请条目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 物品名称
#  number     :integer                                # 物品数量
#  project_id :integer                                # 项目ID
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GoodsProjectApplyItem < ApplicationRecord
  belongs_to :project

  validates :name, :number, presence: true
end
