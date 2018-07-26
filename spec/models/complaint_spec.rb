# == Schema Information
#
# Table name: complaints # 举报表
#
#  id            :bigint(8)        not null, primary key
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人手机
#  content       :text                                   # 举报详情
#  owner_type    :string
#  owner_id      :integer
#  state         :integer                                # 处理状态： 1:submit 2:check
#  remark        :text                                   # 处理备注
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#

require 'rails_helper'

RSpec.describe Complaint, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
