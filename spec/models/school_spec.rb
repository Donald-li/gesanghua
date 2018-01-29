# == Schema Information
#
# Table name: schools # 学校表
#
#  id                :integer          not null, primary key
#  name              :string                                 # 学校名称
#  address           :string                                 # 地址
#  approve_state     :integer          default("submit")     # 审核状态：1:待审核 2:通过 3:不通过
#  approve_remark    :string                                 # 审核备注
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  number            :integer                                # 学校人数
#  describe          :text                                   # 学校简介
#  state             :integer          default("enable")     # 学校状态：1:启用 2:禁用
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  level             :integer                                # 学校等级： 1:初中 2:高中
#  contact_name      :string                                 # 联系人
#  contact_phone     :string                                 # 联系方式
#  contact_position  :string                                 # 联系人职务
#  kind              :integer                                # 学校类型
#  user_id           :integer                                # 申请人ID
#  school_no         :string                                 # 学校申请编号
#  contact_idcard    :string                                 # 联系人身份证号
#  postcode          :string                                 # 邮政编码
#  teacher_count     :integer                                # 教师人数
#  logistic_count    :integer                                # 后勤人数
#  contact_telephone :string                                 # 联系人座机号码
#

require 'rails_helper'

RSpec.describe School, type: :model do

  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  it '测试生成学校编号' do
    time = Time.now.strftime("%y")
    expect(school.school_no).to eq time + '00001'
  end
end
