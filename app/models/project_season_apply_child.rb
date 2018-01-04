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
#

class ProjectSeasonApplyChild < ApplicationRecord
  belongs_to :project
  belongs_to :project_season
  belongs_to :project_season_apply
  belongs_to :gsh_child, optional: true
  has_many :audits, as: :owner

  validates :name, presence: true
  validates :province, :city, :district, presence: true

end
