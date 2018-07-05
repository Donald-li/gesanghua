# == Schema Information
#
# Table name: project_season_apply_inventories # 筹款项目物资清单
#
#  id                            :integer          not null, primary key
#  project_season_apply_id       :integer                                # 项目id
#  name                          :string                                 # 名称
#  unit                          :decimal(14, 2)   default(0.0)          # 单价（元）
#  number                        :integer                                # 数量
#  state                         :integer                                # 状态
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_apply_child_id :integer
#

class ProjectSeasonApplyInventory < ApplicationRecord

  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id

  scope :sorted, ->{ order(created_at: :desc) }

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :unit, :number)
    end.attributes!
  end

end
