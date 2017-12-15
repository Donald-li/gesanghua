# == Schema Information
#
# Table name: teachers # 老师表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 老师姓名
#  nickname   :string                                 # 老师昵称
#  user_id    :integer                                # 用户ID
#  school_id  :integer                                # 学校ID
#  kind       :integer          default(2)            # 老师类型：1:校长 2:老师
#  phone      :string                                 # 老师电话号码
#  state      :integer          default(1)            # 老师状态: 1:启用 2:禁用
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Teacher, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
