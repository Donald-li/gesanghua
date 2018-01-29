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
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  apply_no          :string                                 # 项目申请编号
#  bookshelf_type    :integer                                # 悦读项目申请类型
#  contact_name      :string                                 # 联系人姓名
#  contact_phone     :string                                 # 联系人电话
#  audit_state       :integer                                # 审核状态
#  abstract          :string                                 # 简述
#  address           :string                                 # 详细地址
#  apply_no          :string                                 # 项目申请编号
#

class ProjectSeasonApply < ApplicationRecord
  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :school, optional: true
  belongs_to :teacher, optional: true
  belongs_to :gsh_child, optional: true
  belongs_to :gsh_bookshelf, optional: true
  has_many :audits, as: :owner
  has_many :children, class_name: "ProjectSeasonApplyChild"
  has_many :gsh_child_grants
  has_many :gsh_children
  has_many :gsh_bookshelves

  validates :province, :city, :district, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏

  scope :sorted, -> {order(created_at: :desc)}

  before_create :gen_apply_no

  enum bookshelf_type: {whole: 1, supplement: 2}
  default_value_for :bookshelf_type, 1

  private
  def gen_apply_no
    if self.project_id == 1
      kind = 'JD'
    elsif self.project_id == 2
      kind = 'YD'
    elsif self.project_id == 3
      kind = 'GY'
    elsif self.project_id == 4
      kind = 'TS'
    elsif self.project_id == 5
      kind = 'GB'
    elsif self.project_id == 6
      kind = 'HH'
    else
      kind = 'QT'
    end
    self.apply_no ||= Sequence.get_seq(kind: :apply_no, prefix: kind, length: 7)
  end

end
