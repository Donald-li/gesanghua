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

require 'rails_helper'

RSpec.describe Logistic, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
