# == Schema Information
#
# Table name: grant_batches # 发放批次
#
#  id          :integer          not null, primary key
#  project_id  :integer                                # 所属项目
#  batch_no    :string                                 # 批次号
#  name        :string                                 # 名称
#  description :text                                   # 描述
#  state       :integer                                # 状态
#  user_id     :integer                                # 发放负责人
#  grant_at    :datetime                               # 发放时间
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :grant_batch do
    project
    name "MyString"
    description "MyText"
  end
end
