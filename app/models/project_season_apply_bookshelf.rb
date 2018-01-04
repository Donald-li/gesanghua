# == Schema Information
#
# Table name: project_season_apply_bookshelves # 项目执行年度申请书架表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  gsh_bookshelf_id        :integer                                # 关联格桑花书架id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  amount                  :decimal(14, 2)   default(0.0)          # 筹款金额
#  surplus                 :decimal(14, 2)   default(0.0)          # 剩余捐款额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ProjectSeasonApplyBookshelf < ApplicationRecord
  belongs_to :project
  belongs_to :project_season
  belongs_to :project_season_apply
  belongs_to :gsh_bookshelf, optional: true

  validates :classname, presence: true

end
