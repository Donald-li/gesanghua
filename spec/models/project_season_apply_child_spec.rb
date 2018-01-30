# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  gsh_child_id            :integer                                # 关联格桑花孩子表id
#  name                    :string                                 # 孩子姓名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  phone                   :string                                 # 电话
#  qq                      :string                                 # QQ号码
#  nation                  :integer                                # 民族
#  id_card                 :string                                 # 身份证号码
#  parent_name             :string                                 # 家长姓名
#  description             :text                                   # 描述
#  state                   :integer                                # 状态
#  approve_state           :integer                                # 审核状态
#  age                     :integer                                # 年龄
#  level                   :integer                                # 初中或高中
#  grade                   :integer                                # 年级
#  gender                  :integer                                # 性别
#  school_id               :integer                                # 学校ID
#  semester                :integer                                # 学期
#  kind                    :integer                                # 捐助形式：1对外捐助 2内部认捐
#

require 'rails_helper'

RSpec.describe ProjectSeasonApplyChild, type: :model do
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }
  let!(:child) { create(:project_season_apply_child, project: project, season: season, apply: apply, school: school, semester: 'next_term') }

  it '测试生成格桑花孩子' do
    child.approve_pass # 通过孩子申请

    expect(child.pass?).to be true

    gsh_child = GshChild.first
    expect(gsh_child.name).to eq '李同学'
    expect(gsh_child.gsh_no).to end_with('1')
    expect(gsh_child.semester_count).to eq gsh_child.gsh_child_grants.count
    expect(GshChildGrant.count).to eq 3
    expect(GshChildGrant.first.amount).to eq 1050.0
    expect(GshChildGrant.last.amount).to eq 2100.0
  end

  it '测试结对孩子捐助成功学期的统计计数' do
    child.approve_pass

    gsh_child = child.gsh_child

    grant = gsh_child.gsh_child_grants.pending.first

    grant.donate_state = 'succeed'

    grant.save

    expect(GshChild.find(gsh_child.id).done_semester_count).to eq GshChildGrant.where(gsh_child: gsh_child).succeed.count
    # 筹款进度
    expect(GshChild.find(gsh_child.id).gift_progress).to eq "#{GshChildGrant.where(gsh_child: gsh_child).succeed.count}/#{GshChildGrant.where(gsh_child: gsh_child).count}"
  end

  it '测试查询受助孩子的全部捐助记录' do
    child.approve_pass # 通过孩子申请

    expect(child.donate_all_records.count).to eq 3
    expect(child.donate_all_records.first.amount).to eq 1050.0
    expect(child.donate_all_records.last.amount).to eq 2100.0
  end

  it '测试查询受助孩子的未筹款捐助记录' do
    child.approve_pass # 通过孩子申请

    expect(child.donate_pending_records.count).to eq 3
    expect(child.donate_pending_records.first.amount).to eq 1050.0
    expect(child.donate_pending_records.last.amount).to eq 2100.0
  end

  it '测试查询受助孩子的已筹款捐助记录' do
    child.approve_pass # 通过孩子申请

    expect(child.donate_succeed_records.count).to eq 0
  end
end
