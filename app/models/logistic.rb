# == Schema Information
#
# Table name: logistics # 物流表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 物流公司
#  number     :string                                 # 物流单号
#  owner_type :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Logistic < ApplicationRecord
end
