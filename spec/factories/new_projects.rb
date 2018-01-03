# == Schema Information
#
# Table name: new_projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  protocol   :text                                   # 用户协议
#  fund       :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :new_project do
    
  end
end
