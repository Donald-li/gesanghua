# == Schema Information
#
# Table name: project_templates # 项目模板表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 项目模板名称
#  kind                :integer                                # 模板类型
#  finance_category_id :integer                                # 财务分类ID
#  protocol_name       :string                                 # 协议名称
#  protocol_content    :text                                   # 协议内容
#  contribute_kind     :integer          default(1)            # 捐款类型：1:整捐 2:零捐
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :project_template do
    
  end
end
