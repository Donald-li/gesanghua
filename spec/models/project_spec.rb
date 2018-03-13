# == Schema Information
#
# Table name: projects
#
#  id                         :integer          not null, primary key
#  type                       :string                                      # 单表继承字段
#  kind                       :integer                                     # 项目类型 1:固定项目 2:物资类项目
#  name                       :string                                      # 项目名称
#  describe                   :text                                        # 简介
#  protocol                   :text                                        # 用户协议
#  fund_id                    :integer                                     # 关联财务分类id
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  donate_record_amount_count :decimal(14, 2)   default(0.0)               # 累计捐助金额
#  alias                      :string                                      # 项目别名，使用英文
#  appoint_fund_id            :integer                                     # 定向指定财务分类id
#  position                   :integer                                     # 位置排序
#  form                       :jsonb                                       # 自定义表单{key, label, type, options, required}
#  donate_item_id             :integer                                     # 捐助项id
#  accept_feedback_state      :integer                                     # 是否接受定期反馈：1:open_feedback 2:close_feedback
#  feedback_period            :integer                                     # 建议定期反馈次数/年
#  apply_kind                 :integer          default("platform_assign") # 申请类型 1:平台分配 2:用户申请
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:project, :with_seasons) }
  let(:fund_category) { create(:fund_category, name: '自定义物资类', describe: '自定义物资类项目财务分类')}
  let(:fund) { create(:fund, name: '爱心早餐', fund_category: fund_category)}
  let(:custom_project) { create(:project, name: '物资类爱心早餐', fund: fund)}

  it '测试项目数据完整性' do
    user = create(:user)
    school = create(:school)
    teacher = create(:teacher, school: school, user: user)
    project = create(:project)
    season = create(:project_season, project: project)
    apply = create(:project_season_apply, project: project, season: season, teacher: teacher)
    child = create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)
  end

  it '测试一对一项目基本操作' do
    expect(project.seasons.first.name).to eq '2017'
    expect(project.valid?).to be true
    expect(project.name).to eq '一对一'
  end

  it '测试新增自定义项目' do
    expect(custom_project.name).to eq '物资类爱心早餐'
    expect(custom_project.fund.id).to eq fund.id
  end
end
