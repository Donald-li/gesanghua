# == Schema Information
#
# Table name: project_season_apply_bookshelves # 项目执行年度申请书架表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  amount                  :decimal(14, 2)   default(0.0)          # 筹款金额
#  surplus                 :decimal(14, 2)   default(0.0)          # 剩余捐款额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  school_id               :integer                                # 学校id
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  audit_state             :integer                                # 审核状态 1:提交 2:通过 3:拒绝
#  show_state              :integer                                # 显示状态 1:显示 2:隐藏
#  state                   :integer                                # 筹款状态:
#  grade                   :integer                                # 年级
#

class ProjectSeasonApplyBookshelf < ApplicationRecord
  belongs_to :project
  belongs_to :project_season
  belongs_to :project_season_apply
  belongs_to :gsh_bookshelf, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id'
  belongs_to :school

  has_many :donates, class_name: 'DonateRecord', dependent: :destroy

  scope :gsh_bookshelf, -> { complete }

  validates :classname, presence: true

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {pending: 1, complete: 2, non_execution: 3, non_reception: 4, non_feedback: 5, done: 6}
  default_value_for :state, 1

  enum grade: {juniorone: 1, juniortwo: 2, juniorthree: 3, seniorone: 4, seniortwo: 5, seniorthree: 6}
  default_value_for :grade, 1
end
