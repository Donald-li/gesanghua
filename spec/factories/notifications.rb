# == Schema Information
#
# Table name: notifications
#
#  id                      :bigint(8)        not null, primary key
#  push_type               :integer                                # bit_enum，邮件、短信、微信
#  kind                    :string                                 # 类型，通知类型
#  from_user_id            :integer                                # 发起用户
#  user_id                 :integer                                # 通知用户
#  project_id              :integer                                # 项目
#  project_season_id       :integer                                # 批次
#  project_season_apply_id :integer                                # 申请
#  owner_type              :string
#  owner_id                :integer
#  content                 :text                                   # 内容
#  read                    :boolean                                # 是否已读
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  title                   :string                                 # 消息标题
#

FactoryBot.define do
  factory :notification do
    
  end
end
