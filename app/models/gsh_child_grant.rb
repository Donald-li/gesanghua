# == Schema Information
#
# Table name: gsh_child_grants # 格桑花孩子发放表
#
#  id                            :integer          not null, primary key
#  gsh_child_id                  :integer                                # 关联孩子表id
#  project_season_apply_id       :integer                                # 关联申请表
#  state                         :integer                                # 状态 1:为筹款 2:待发放 3:发放完成
#  amount                        :decimal(14, 2)   default(0.0)          # 发放金额
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  school_id                     :integer                                # 学校ID
#  project_season_id             :integer                                # 批次ID
#  donate_state                  :integer                                # 捐助状态
#  grant_no                      :string                                 # 格桑花发放编号
#  granted_at                    :datetime                               # 发放时间
#  grant_remark                  :text                                   # 发放说明
#  delay_reason                  :string                                 # 暂缓发放原因
#  delay_remark                  :text                                   # 暂缓发放备注
#  balance_manage                :integer                                # 取消余额处理
#  cancel_remark                 :text                                   # 取消说明
#  title                         :string                                 # 标题
#  remark                        :text
#  operator_id                   :integer                                # 异常处理人id
#  grant_person                  :string                                 # 发放人
#  user_id                       :integer                                # 捐助人
#  grant_batch_id                :integer                                # 发放批次
#  project_season_apply_child_id :integer                                # 一对一助学孩子id
#  cancel_reason                 :integer                                # 取消原因
#  management_fee_state          :integer                                # 计提管理费状态
#  grade_name                    :string                                 # 年级名称
#  feedback_count                :integer
#

# 一对一孩子发放表
class GshChildGrant < ApplicationRecord
  has_paper_trail only: [:gsh_child_id, :project_season_apply_id, :amount, :school_id, :state, :project_season_id, :donate_state, :grant_no, :granted_at,
  :grant_remark, :delay_reason, :delay_remark, :balance_manage, :cancel_remark, :title, :operator_id, :grant_person, :user_id, :grant_batch_id, :project_season_apply_child_id, :cancel_reason]

  include HasAsset
  has_many_assets :images, class_name: 'Asset::GshChildGrantImage'

  belongs_to :school, optional: true
  belongs_to :user, optional: true
  belongs_to :gsh_child, class_name: 'GshChild', optional: true #
  # TPDP
  belongs_to :apply_child, class_name: 'ProjectSeasonApplyChild', foreign_key: :project_season_apply_child_id, optional: true
  belongs_to :project_season, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: :project_season_id, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :operator, class_name: 'User', foreign_key: 'operator_id', optional: true
  belongs_to :grant_batch, optional: true
  belongs_to :donator, class_name: 'User', foreign_key: 'user_id', optional: true # 捐助人

  has_many :donate_records, as: :owner, dependent: :nullify

  has_one :feedback, as: :owner
  has_many :thank_notes, class_name: 'Feedback', foreign_key: 'gsh_child_grant_id'

  enum state: {waiting: 1, granted: 2, suspend: 3, cancel: 4}
  default_value_for :state, 1

  enum cancel_reason: {drop_out: 1, demand: 2} # 1:辍学 2:捐助人要求

  enum donate_state: {pending: 1, succeed: 2, refund: 3, close: 4} # 捐助状态：1:未筹款 2:已筹款 4:关闭
  default_value_for :donate_state, 1
  default_value_for :feedback_count, 0

  enum management_fee_state: {unaccrue: 0, accrued: 2} # 状态：1:未计提 2:已计提
  default_value_for :management_fee_state, 0

  enum balance_manage: {transfer: 1, send_back: 2} # TODO: 废弃 捐助状态 1:转捐 2:退回
  # default_value_for :balance_manage, 2

  scope :sorted, ->(){ order(id: :asc) }
  scope :reverse_sorted, ->{ sorted.reverse_order }
  scope :visible, -> { where(donate_state: [:pending, :succeed]) }

  counter_culture :gsh_child, column_name: "semester_count"
  counter_culture :gsh_child, column_name: proc {|model| model.succeed? ? 'done_semester_count' : nil }
  counter_culture :apply_child, column_name: "semester_count"
  counter_culture :apply_child, column_name: proc {|model| model.succeed? ? 'done_semester_count' : nil }

  before_create :set_assoc_attrs
  after_save :gen_grant_no

  # TODO: 现在没有project_id, 以后可以增加这个字段
  def project
    Project.pair_project
  end

  # 统一显示名称
  def show_name
    self.apply_child.try(:name) + ' ' + self.title
  end

  def target_amount
    self.amount
  end

  def search_title
    "#{self.apply_child.try(:name)}（#{self.apply_child.try(:gsh_no)}|#{self.apply_child.try(:id_card)}）#{self.title}"
  end

  # 使用捐助
  def accept_donate(donate_records)
    # TODO: 得防止重复捐助
    donate_record = donate_records.last
    amount = [surplus_money, donate_record.amount].min
    donate_record.update!(amount: amount)

    self.apply.present_amount += amount
    self.donate_state = 'succeed'
    self.user_id = donate_record.donor_id
    self.save!
    self.apply_child.update_state(self.user_id)
  end

  # 退款, 捐助记录退款状态，退回账户余额，孩子标记取消
  def do_refund!(operator)
    record = self.donate_records.last
    return false unless record.present?
    record.do_refund!(operator)
  end

  def can_refund?
    record = self.donate_records.last
    return false unless record.present?
    (record.user_donate? || ['IncomeRecord', 'User'].include?(record.source_type)) && record.agent.present? && record.owner_type == 'GshChildGrant' && (record.owner.waiting? || record.owner.suspend?)
  end

  def button_color
    if self.pending?
      'yellow'
    elsif self.succeed?
      'green'
    else
      'grey'
    end
  end

  def surplus_money
    self.amount
  end

  def self.gen_grant_record(child)
    gsh_child = child.gsh_child
    apply = child.apply
    season = apply.season

    if child.junior?
      term_amount = season.junior_term_amount
      year_amount = season.junior_year_amount
    elsif child.senior?
      term_amount = season.senior_term_amount
      year_amount = season.senior_year_amount
    end

    apply_num = 4 - child.child_grade_integer

    year = Time.now.year

    if child.next_term? && apply_num > 0
      GshChildGrant.find_or_create_by(title: "#{year}.3 - #{year}.7 学期", gsh_child: gsh_child, apply_child: child, apply: apply, amount: term_amount, school_id: child.school_id)
      apply_num -= 1
    end

    if (apply_num > 0)
      apply_num.times do
        GshChildGrant.find_or_create_by(title: "#{year}.9 - #{year + 1}.7 学年", gsh_child: gsh_child, apply_child: child, apply: apply, amount: year_amount, school_id: child.school_id)
        year += 1
      end
    end

  end

  #用于操作用户查找关系
  def project_season_apply
    self.apply
  end

  def project_season_apply_child
    self.apply_child
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :amount, :donate_state, :grant_batch_id)
      json.child_name gsh_child.name
      json.gsh_no gsh_child.gsh_no
      json.state self.enum_name(:state)
    end.attributes!
  end

  def gen_grant_no
    if self.state == 'granted'
      # 不需要发放编号了
      # self.grant_no ||= Sequence.get_seq(kind: :grant_no, prefix: self.gsh_child.try(:gsh_no) + Time.now.strftime('%y%m%d'), length: 3)
    end
  end

  private
  def set_assoc_attrs
    return unless child = self.apply_child
    self.project_season_id ||= child.project_season_id
    self.project_season_apply_id ||= child.project_season_apply_id
  end

end
