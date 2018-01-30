# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id                  :integer          not null, primary key
#  school_id           :integer                                # 关联学校id
#  name                :string                                 # 孩子姓名
#  province            :string                                 # 省
#  city                :string                                 # 市
#  district            :string                                 # 区/县
#  gsh_no              :string                                 # 格桑花孩子编号
#  phone               :string                                 # 联系电话
#  qq                  :string                                 # qq号
#  user_id             :integer                                # 关联用户id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  idcard              :string                                 # 身份证
#  semester_count      :integer                                # 孩子申请学期总数
#  done_semester_count :integer                                # 孩子募款成功学期总数
#

FactoryBot.define do
  factory :gsh_child do
    name {"#{FFaker::NameCN.name}"}
    province '630000'
    city '630100'
    district '630123'
  end
end
