# == Schema Information
#
# Table name: gsh_bookshelves
#
#  id                      :integer          not null, primary key
#  school_id               :integer                                # 关联学校id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  bookshelf_no            :string                                 # 图书角编号
#  univalence              :decimal(14, 2)   default(0.0)          # 单个金额
#  balance                 :decimal(14, 2)   default(0.0)          # 单个筹款剩余金额
#  extra_amount            :decimal(14, 2)   default(0.0)          # 补书金额
#  audit_state             :integer                                # 审核状态
#  show_state              :integer                                # 展示状态
#  state                   :integer                                # 执行状态
#  project_season_apply_id :integer                                # 项目申请ID
#  project_season_id       :integer                                # 批次申请ID
#  grade                   :integer                                # 所属年级
#  student_number          :integer                                # 班级人数
#  loss                    :integer                                # 书籍损耗
#  supplement              :integer                                # 书籍补充
#

class GshBookshelf < ApplicationRecord

  belongs_to :project_season_apply, optional: true
  belongs_to :project_season, optional: true
  belongs_to :school, optional: true
  has_many :beneficial_children
  has_many :audits, as: :owner

  validates :classname, presence: true

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {pending: 1, complete: 2, non_execution: 3, non_reception: 4, non_feedback: 5, done: 6}
  default_value_for :state, 1

  enum grade: {juniorone: 1, juniortwo: 2, juniorthree: 3, seniorone: 4, seniortwo: 5, seniorthree: 6}
  default_value_for :grade, 1

  scope :pass_done, ->{ where(audit_state: 2,state: 6) }

  scope :sorted, ->{ order(created_at: :desc) }

  private

  def gen_bookshelf_no
    time_string = Time.now.strftime("%y%m%d%H")
    self.donate_no ||= Sequence.get_seq(kind: :donate_no, prefix: time_string, length: 7)
  end
end
