# == Schema Information
#
# Table name: logistics # 物流表
#
#  id         :integer          not null, primary key
#  name       :integer                                # 物流公司 1:顺丰
#  number     :string                                 # 物流单号
#  owner_type :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 物流信息
class Logistic < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :name, :number, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  # enum name: { shunfeng: 1, shentong: 2, zhongtong: 3 }

  enum name: {'shunfeng': 2, 'yuantong': 3, 'shentong': 4, 'yunda': 5, 'zhongtong': 6, 'huitongkuaidi': 7, 'tiantian': 8, 'ems': 9, 'else': 10}

  def qurey_result
    if self.else?
      "https://www.kuaidi100.com/"
    else
      "https://www.kuaidi100.com/chaxun?com=#{self.name}&nu=#{self.number}"
    end
  end

end
