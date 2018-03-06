# == Schema Information
#
# Table name: camp_document_resources # 拓展营资源表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 项目
#  user_id           :integer                                # 用户
#  company           :string                                 # 单位名称
#  resource          :string                                 # 资源名称
#  contact_name      :string                                 # 联系人
#  contact_phone     :string                                 # 联系人电话
#  gsh_contact_name  :string                                 # 格桑花联系人
#  gsh_contact_phone :string                                 # 格桑花联系人电话
#  remark            :string                                 # 资源说明
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :camp_project_resource do
    project_season_id 1
    user_id 1
    company "MyString"
    resource "MyString"
    contact_name "MyString"
    contact_phone "MyString"
    gsh_contact_name "MyString"
    gsh_contact_phone "MyString"
    remark "MyString"
  end
end
