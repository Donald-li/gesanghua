# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :bigint(8)        not null, primary key
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
#  donate_user_id          :integer                                # 捐助人id
#  reason                  :string                                 # 结对申请理由
#  gsh_no                  :string                                 # 格桑花孩子编号
#  semester_count          :integer                                # 学期数
#  done_semester_count     :integer          default(0)            # 已完成的学期数
#  user_id                 :integer                                # 关联的用户ID
#  teacher_name            :string                                 # 班主任
#  father                  :string                                 # 父亲
#  father_job              :string                                 # 父亲职业
#  mother                  :string                                 # 母亲
#  mother_job              :string                                 # 母亲职业
#  guardian                :string                                 # 监护人
#  guardian_relation       :string                                 # 与监护人关系
#  guardian_phone          :string                                 # 监护人电话
#  address                 :string                                 # 家庭住址
#  family_income           :decimal(14, 2)   default(0.0)          # 家庭年收入
#  family_expenditure      :decimal(14, 2)   default(0.0)          # 家庭年支出
#  income_source           :string                                 # 收入来源
#  family_condition        :string                                 # 家庭情况
#  brothers                :string                                 # 兄弟姐妹
#  teacher_phone           :string                                 # 班主任联系方式
#  remark                  :text                                   # 备注
#  expenditure_information :text                                   # 支出详情
#  debt_information        :text                                   # 负债情况
#  parent_information      :string                                 # 父母情况
#  information             :text                                   # 对外展示的孩子介绍
#  classname               :string                                 # 班级名称
#  priority_id             :integer                                # 优先捐助人id
#  archive_data            :jsonb                                  # 归档旧数据
#  student_state           :integer          default("normal")     # 学生状态
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

    child = ProjectSeasonApplyChild.first
    expect(child.name).to eq '李同学'
    expect(child.gsh_no).to end_with('1')
    expect(child.semester_count).to eq child.gsh_child_grants.count
    expect(GshChildGrant.first.amount).to eq 1050.0
    expect(GshChildGrant.last.amount).to eq 2100.0
  end

  it '测试结对助学孩子捐助成功学期的统计计数' do
    child.approve_pass

    grant = child.gsh_child_grants.pending.first

    grant.donate_state = 'succeed'

    grant.save

    expect(ProjectSeasonApplyChild.find(child.id).done_semester_count).to eq GshChildGrant.where(apply_child: child).succeed.count
    # 筹款进度
    expect(ProjectSeasonApplyChild.find(child.id).gift_progress).to eq "#{GshChildGrant.where(apply_child: child).succeed.count} / #{GshChildGrant.where(apply_child: child).count}"
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
    expect(child.donate_pending_records.first.amount).to eq 2100.0
    expect(child.donate_pending_records.last.amount).to eq 1050.0
  end

  it '测试查询受助孩子的已筹款捐助记录' do
    child.approve_pass # 通过孩子申请

    expect(child.donate_succeed_records.count).to eq 0
  end
end
