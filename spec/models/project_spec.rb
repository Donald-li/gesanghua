# == Schema Information
#
# Table name: new_projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  protocol   :text                                   # 用户协议
#  fund       :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { build(:hair_project) }

  it '测试结对项目基本操作' do
    # project.name = '结对'
    # project.save
    expect(project.valid?).to be true
    expect(project.name).to eq '结对'
    expect(project.normal?).to be true
  end
end
