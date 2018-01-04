# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 关联学校id
#  name       :string                                 # 孩子姓名
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  gsh_no     :string                                 # 格桑花孩子编号
#  phone      :string                                 # 联系电话
#  qq         :string                                 # qq号
#  user_id    :integer                                # 关联用户id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe GshChild, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
