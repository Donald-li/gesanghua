# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id                 :integer          not null, primary key
#  project_id         :integer                                # 关联项目表id
#  name               :string                                 # 执行年度名称
#  state              :integer                                # 状态 1:未执行 2:执行中
#  junior_term_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学期）
#  junior_year_amount :decimal(14, 2)   default(0.0)          # 初中资助金额（学年）
#  senior_term_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学期）
#  senior_year_amount :decimal(14, 2)   default(0.0)          # 高中资助金额（学年）
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeason, type: :model do
  let(:project) { build(:hair_project) }

  it '测试结对项目基本操作' do
    # project.name = '结对'
    # project.save
    expect(project.valid?).to be true
    expect(project.name).to eq '结对'
    expect(project.normal?).to be true
  end
end
