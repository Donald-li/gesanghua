# == Schema Information
#
# Table name: donation_use_logs # 捐款使用路径
#
#  id                      :integer          not null, primary key
#  income_record_id        :integer                                # 入账记录id
#  project_season_apply_id :integer                                # 项目批次申请id
#  donate_record_id        :integer                                # 捐助记录id
#  user_id                 :integer                                # 用户id
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :donation_use_log do
    
  end
end
