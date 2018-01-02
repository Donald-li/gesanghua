# == Schema Information
#
# Table name: project_quota # 项目配额
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 学校ID
#  project_id :integer                                # 项目ID
#  number     :integer                                # 学生数量
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :project_quotum, class: 'ProjectQuota' do
    school_id 1
    project_id 1
    amount "9.99"
    province "MyString"
    city "MyString"
    district "MyString"
  end
end
