# == Schema Information
#
# Table name: project_quota # 项目配额
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 学校ID
#  project_id :integer                                # 项目ID
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectQuota, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
