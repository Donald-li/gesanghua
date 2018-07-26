# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id                  :bigint(8)        not null, primary key
#  name                :string                                 # 孩子姓名
#  kind                :integer                                # 类型
#  workstation         :string                                 # 工作地点
#  province            :string                                 # 省
#  city                :string                                 # 市
#  district            :string                                 # 区/县
#  gsh_no              :string                                 # 格桑花孩子编号
#  phone               :string                                 # 联系电话
#  qq                  :string                                 # qq号
#  user_id             :integer                                # 关联用户id
#  id_card             :string                                 # 身份证
#  semester_count      :integer          default(0)            # 孩子申请学期总数
#  done_semester_count :integer          default(0)            # 孩子募款成功学期总数
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :gsh_child do
    name {"#{FFaker::NameCN.name}"}
    province '630000'
    city '630100'
    district '630123'
  end
end
