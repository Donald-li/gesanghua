# == Schema Information
#
# Table name: complaints # 举报表
#
#  id            :integer          not null, primary key
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人手机
#  content       :text                                   # 举报详情
#  owner_type    :string
#  owner_id      :integer
#  state         :integer                                # 处理状态： 1:submit 2:check
#  remark        :text                                   # 处理备注
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :complaint do
    contact_name "MyString"
    contact_phone "MyString"
    content "MyText"
    owner_type "MyString"
    owner_id 1
  end
end
