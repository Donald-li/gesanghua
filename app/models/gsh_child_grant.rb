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
#  cancel_reason                 :string                                 # 取消原因
#  balance_manage                :integer                                # 取消余额处理
#  cancel_remark                 :text                                   # 取消说明
#  title                         :string                                 # 标题
#  remark                        :text
#  operator_id                   :integer                                # 异常处理人id
#  grant_person                  :string                                 # 发放人
#  user_id                       :integer                                # 捐助人
#  grant_batch_id                :integer                                # 发放批次
#  project_season_apply_child_id :integer                                # 一对一助学孩子id
#

# 一对一孩子发放表
class GshChildGrant < ApplicationRecord

  include HasAsset
  has_many_assets :images, class_name: 'Asset::GshChildGrantImage'

  belongs_to :school, optional: true
  belongs_to :user, optional: true
  belongs_to :gsh_child, class_name: 'GshChild', optional: true #
  # TPDP
  belongs_to :apply_child, class_name: 'ProjectSeasonApplyChild', foreign_key: :project_season_apply_child_id, optional: true
  belongs_to :project_season, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :operator, class_name: 'User', foreign_key: 'operator_id', optional: true
  belongs_to :grant_batch, optional: true
  belongs_to :donator, class_name: 'User', foreign_key: 'user_id', optional: true # 捐助人

  has_one :feedback, as: :owner
  has_many :thank_notes, class_name: 'Feedback', foreign_key: 'gsh_child_grant_id'

  enum state: {waiting: 1, granted: 2, suspend: 3, cancel: 4}
  default_value_for :state, 1

  enum donate_state: {pending: 1, succeed: 2} # 捐助状态：1:未筹款 2:已筹款
  default_value_for :donate_state, 1

  enum balance_manage: {transfer: 1, send_back: 2} # 捐助状态 1:转捐 2:退回
  # default_value_for :balance_manage, 0

  scope :sorted, ->(){ order(id: :asc) }
  scope :reverse_sorted, ->{ sorted.reverse_order }

  counter_culture :gsh_child, column_name: "semester_count"
  counter_culture :gsh_child, column_name: proc {|model| model.succeed? ? 'done_semester_count' : nil }
  counter_culture :apply_child, column_name: "semester_count"
  counter_culture :apply_child, column_name: proc {|model| model.succeed? ? 'done_semester_count' : nil }

  # 使用捐助
  def accept_donate(donate_records)
    donate_records.each do |donate_record|
      self.apply.present_amount += donate_record.amount
      self.project.appoint_fund.balance += donate_record.amount
    end
    self.donate_state = 'succeed'
    self.save!
    self.apply_child.update_state
  end

  def self.gen_grant_record(child)
    gsh_child = child.gsh_child
    apply = child.apply

    if child.junior?
      term_amount = Settings.junior_term_amount
      year_amount = Settings.junior_year_amount
    elsif child.senior?
      term_amount = Settings.senior_term_amount
      year_amount = Settings.senior_year_amount
    end

    apply_num = 4 - child.child_grade_integer

    year = Time.now.year

    GshChildGrant.find_or_create_by(title: "#{year} 春季", gsh_child: gsh_child, apply_child: child, apply: apply, amount: term_amount, school_id: child.school_id) && apply_num -= 1 if child.next_term? && apply_num > 0

    if (apply_num > 0)
      apply_num.times do
        GshChildGrant.find_or_create_by(title: "#{year} - #{year + 1} 学年", gsh_child: gsh_child, apply_child: child, apply: apply, amount: year_amount, school_id: child.school_id)
        year += 1
      end
    end

    # child.semester

  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :amount, :donate_state, :grant_batch_id)
      json.child_name gsh_child.name
      json.gsh_no gsh_child.gsh_no
      json.state self.enum_name(:state)
    end.attributes!
  end

end
