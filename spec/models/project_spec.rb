# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  describe   :text                                   # 简介
#  protocol   :text                                   # 用户协议
#  fund_id    :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

<<<<<<< HEAD
#  id                 :integer          not null, primary key
#  type               :string                                 # 单表继承字段
#  kind               :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name               :string                                 # 项目名称
#  describe           :text                                   # 简介
#  protocol           :text                                   # 用户协议
#  fund               :integer                                # 关联财务分类id
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  junior_term_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
=======
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  describe   :text                                   # 简介
#  protocol   :text                                   # 用户协议
#  fund_id    :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
>>>>>>> 554394f4b9ee31f1201ffe57283adc8e6eac2e58
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:project, :with_seasons) }

  it '测试项目数据完整性' do
    user = create(:user)
    school = create(:school)
    teacher = create(:teacher, school: school, user: user)
    project = create(:project)
    season = create(:project_season, project: project)
    apply = create(:project_season_apply, project: project, project_season: season, teacher: teacher)
    child = create(:project_season_apply_child, project: project, project_season: season, project_season_apply: apply, school: school)
  end

  it '测试结对项目基本操作' do
    expect(project.seasons.first.name).to eq '2017'
    expect(project.valid?).to be true
    expect(project.name).to eq '结对'
    expect(project.normal?).to be true
  end
end
