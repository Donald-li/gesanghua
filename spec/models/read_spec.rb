# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  describe   :text                                   # 简介
#  protocol   :text                                   # 用户协议
#  fund_id    :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Read, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
