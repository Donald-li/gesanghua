# == Schema Information
#
# Table name: family_members # 家庭成员表
#
#  id               :integer          not null, primary key
#  visit_id         :integer                                # 家访表ID
#  name             :string                                 # 成员姓名
#  age              :integer                                # 年龄
#  relationship     :string                                 # 关系
#  profession       :string                                 # 职业
#  health_condition :text                                   # 健康状况
#  job_condition    :text                                   # 工作情况
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe FamilyMember, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
