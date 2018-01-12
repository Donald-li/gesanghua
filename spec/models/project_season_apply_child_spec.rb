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

  it '测试生成格桑花孩子' do
    user = create(:user)
    school = create(:school, user: user)
    teacher = create(:teacher, school: school, user: user)
    project = create(:project)
    season = create(:project_season, project: project)
    apply = create(:project_season_apply, project: project, project_season: season, teacher: teacher, school: school)
    child = create(:project_season_apply_child, project: project, project_season: season, project_season_apply: apply, school: school, semester: 'next_term')

    # 通过孩子申请
    child.approve_pass

    expect(child.pass?).to be true

    gsh_child = GshChild.first
    expect(gsh_child.name).to eq '李同学'
    expect(gsh_child.gsh_no).to end_with('1')
    expect(child.project_season_apply.gsh_child).to eq gsh_child

    expect(GshChildGrant.count).to eq 3
    expect(GshChildGrant.first.amount).to eq 1050.0
    expect(GshChildGrant.last.amount).to eq 2100.0

  end
end
