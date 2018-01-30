# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id                 :integer          not null, primary key
#  level              :integer                                # 等级
#  major_id           :integer                                # 专业id
#  duration           :integer                                # 服务时长
#  user_id            :integer                                # 用户
#  job_state          :integer                                # 任务状态
#  state              :integer                                # 状态
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  kind               :integer                                # 类型
#  approve_state      :integer                                # 认证状态
#  approve_time       :datetime                               # 认证时间
#  approve_remark     :text                                   # 审核备注
#  volunteer_no       :string                                 # 志愿者编号
#  volunteer_apply_no :string                                 # 志愿者申请编号
#

require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  let!(:user) { create(:user) }
  let!(:volunteer) { create(:volunteer, user: user) }

  it '测试生成志愿者申请编号' do
    time = Time.now.strftime("%y%m%d")
    expect(volunteer.volunteer_apply_no).to eq time + '0001'
  end

  it '测试生成志愿者编号' do
    volunteer.gen_volunteer_no
    volunteer.save
    time = Time.now.strftime("%y")
    expect(volunteer.volunteer_no).to eq 'ZYZ' + time + '0001'
  end

end
