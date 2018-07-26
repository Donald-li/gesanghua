# == Schema Information
#
# Table name: project_season_apply_inventories # 筹款项目物资清单
#
#  id                            :bigint(8)        not null, primary key
#  project_season_apply_id       :integer                                # 项目id
#  name                          :string                                 # 名称
#  unit                          :decimal(14, 2)   default(0.0)          # 单价（元）
#  number                        :integer                                # 数量
#  state                         :integer                                # 状态
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_apply_child_id :integer
#

FactoryBot.define do
  factory :project_season_apply_inventory do
    project_season_apply_id 1
    name "MyString"
    unit "9.99"
    number 1
    state 1
  end
end
