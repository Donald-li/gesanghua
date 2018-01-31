# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度的id
#  school_id         :integer                                # 关联学校id
#  teacher_id        :integer                                # 负责项目的老师id
#  describe          :text                                   # 描述、申请要求
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  state             :integer          default("show")       # 状态：1:展示 2:隐藏
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  apply_no          :string                                 # 项目申请编号
#  bookshelf_type    :integer                                # 悦读项目申请类型
#  contact_name      :string                                 # 联系人姓名
#  contact_phone     :string                                 # 联系人电话
#  audit_state       :integer                                # 审核状态
#  abstract          :string                                 # 简述
#  address           :string                                 # 详细地址
#  girl_number       :integer                                # 申请女生人数
#  boy_number        :integer                                # 申请男生人数
#  consignee         :string                                 # 收货人
#  consignee_phone   :string                                 # 收货人联系电话
#  target_amount     :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  execute_state     :integer          default("default")    # 执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成
#  project_type      :integer          default("apply")      # 项目类型:1:申请 2:筹款项目
#  class_number      :integer                                # 申请班级数
#  student_number    :integer                                # 受益学生数
#

require 'rails_helper'

RSpec.describe ProjectSeasonApply, type: :model do
  before(:all) do
    @user = create(:user)
    @project = create(:project)
    @project_season = create(:project_season, project_id: @project.id)
    @project_season_apply = create(:project_season_apply, project_id: @project.id, project_season_id: @project_season.id)
  end

  it '测试生成项目编号' do
    if @project_season_apply.project_id == 1
      kind = 'JD'
    elsif @project_season_apply.project_id == 2
      kind = 'YD'
    elsif @project_season_apply.project_id == 3
      kind = 'GY'
    elsif @project_season_apply.project_id == 4
      kind = 'TS'
    elsif @project_season_apply.project_id == 5
      kind = 'GB'
    elsif @project_season_apply.project_id == 6
      kind = 'HH'
    else
      kind = 'QT'
    end
    expect(@project_season_apply.apply_no).to eq kind + '0000001'
  end
end
