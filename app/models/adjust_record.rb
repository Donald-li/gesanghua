# == Schema Information
#
# Table name: adjust_records # 分类调整记录
#
#  id           :integer          not null, primary key
#  from_fund_id :integer                                # 从哪个分类
#  to_fund_id   :integer                                # 调到哪个分类
#  amount       :decimal(14, 2)   default(0.0)          # 金额
#  user_id      :integer                                # 操作人
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class AdjustRecord < ApplicationRecord

  belongs_to :from_fund, class_name: 'Fund', foreign_key: :from_fund_id
  belongs_to :to_fund, class_name: 'Fund', foreign_key: :to_fund_id
  belongs_to :user

end
