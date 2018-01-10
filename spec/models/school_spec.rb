# == Schema Information
#
# Table name: schools # 学校表
#
#  id               :integer          not null, primary key
#  name             :string                                 # 学校名称
#  address          :string                                 # 地址
#  approve_state    :integer          default(1)            # 审核状态：1:待审核 2:通过 3:不通过
#  approve_remark   :string                                 # 审核备注
#  province         :string                                 # 省
#  city             :string                                 # 市
#  district         :string                                 # 区/县
#  number           :integer                                # 学校人数
#  describe         :string                                 # 学校简介
#  state            :integer          default("enabled")    # 学校状态：1:启用 2:禁用
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  level            :integer                                # 学校等级： 1:初中 2:高中
#  contact_name     :string                                 # 联系人
#  contact_phone    :string                                 # 联系方式
#  contact_position :string                                 # 联系人职务
#  kind             :integer                                # 学校类型
#  user_id          :integer                                # 用户id
#

require 'rails_helper'

RSpec.describe School, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
