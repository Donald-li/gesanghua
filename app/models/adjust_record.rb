# == Schema Information
#
# Table name: adjust_records # 分类调整记录
#
#  id           :integer          not null, primary key
#  from_item_id    :integer                                # 从哪个分类
#  from_item_type    :string                                # 从哪个分类
#  to_item_type    :string                                # 从哪个分类
#  to_item_id      :integer                                # 调到哪个分类
#  amount       :decimal(14, 2)   default(0.0)          # 金额
#  user_id      :integer                                # 操作人
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AdjustRecord < ApplicationRecord

  belongs_to :from_item, polymorphic: true
  belongs_to :to_item, polymorphic: true
  belongs_to :user

  scope :sorted, -> {order(created_at: :desc)}

end
