# == Schema Information
#
# Table name: volunteers # 志愿者表
#
#  id                 :integer          not null, primary key
#  level              :integer                                # 等级
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
#  internship_state   :integer                                # 实习还是正式
#  describe           :text                                   # 个人简介
#  phone              :string                                 # 手机号
#  workstation        :string                                 # 工作单位
#  leave_reason       :jsonb                                  # 请假原因[类型, 说明]
#  task_state         :boolean          default(FALSE)        # 志愿者是否有未查看的指派任务
#  name               :string                                 # 志愿者真实姓名
#  id_card            :string                                 # 志愿者身份证
#  province           :string                                 # 省
#  city               :string                                 # 市
#  district           :string                                 # 区县
#  address            :string                                 # 详细地址
#  gender             :integer                                # 性别
#  source             :string                                 # 获知渠道
#  experience         :text                                   # 志愿者经历
#

require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  let!(:user) { create(:user) }
  let!(:volunteer) { create(:volunteer, user: user) }

  describe '测试生成志愿者编号' do
    it '生成志愿者申请编号' do
      expect(volunteer.volunteer_apply_no.present?).to eq true
    end

    it '生成志愿者编号' do
      volunteer.gen_volunteer_no
      expect(volunteer.volunteer_no.present?).to eq true
    end
  end
end
