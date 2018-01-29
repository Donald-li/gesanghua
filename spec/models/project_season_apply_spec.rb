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
#  gsh_child_id      :integer                                # 关联格桑花孩子id
#  gsh_bookshelf_id  :integer                                # 关联格桑花书架(图书角)id
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  apply_no          :string                                 # 项目申请编号
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
