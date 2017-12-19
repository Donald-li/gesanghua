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

class Logistic < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :name, :number, presence: true

  scope :sorted, ->{ order(created_at: :desc) }
end
