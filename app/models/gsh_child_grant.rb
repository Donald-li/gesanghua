# == Schema Information
#
# Table name: gsh_child_grants # 格桑花孩子发放表
#
#  id                      :integer          not null, primary key
#  gsh_child_id            :integer                                # 关联孩子表id
#  project_season_apply_id :integer                                # 关联申请表
#  state                   :integer                                # 状态 1:为筹款 2:待发放 3:发放完成
#  amount                  :decimal(14, 2)   default(0.0)          # 发放金额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  school_id               :integer                                # 学校ID
#  project_season_id       :integer                                # 批次ID
#  donate_state            :integer                                # 捐助状态
#  grant_no                :string                                 # 格桑花发放编号
#  granted_at              :datetime                               # 发放时间
#  grant_remark            :text                                   # 发放说明
#  delay_reason            :string                                 # 暂缓发放原因
#  delay_remark            :text                                   # 暂缓发放备注
#  cancel_reason           :string                                 # 取消原因
#  balance_manage          :integer                                # 取消余额处理
#  cancel_remark           :text                                   # 取消说明
#  title                   :string                                 # 标题
#  remark                  :text
#

class GshChildGrant < ApplicationRecord
  include HasAsset
  has_many_assets :images, class_name: 'Asset::GshChildGrantImage'

  belongs_to :school, optional: true
  belongs_to :gsh_child, optional: true
  belongs_to :project_season, optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true

  has_one :feedback, as: :owner

  enum state: {waiting: 1, granted: 2, suspend: 3, cancel: 4}
  default_value_for :state, 1

  enum donate_state: {pending: 1, succeed: 2} # 捐助状态：1:未筹款 2:已筹款
  default_value_for :donate_state, 1

  enum balance_manage: {balance_default: 0, transfer: 1, send_back: 2} # 捐助状态：0:默认 1:转捐 2:退回
  default_value_for :balance_manage, 0

  scope :sorted, ->{ order(created_at: :desc) }
  scope :reverse_sorted, ->{ order(created_at: :asc) }

  def self.gen_grant_record(gsh_child)
    child = gsh_child.apply_child
    apply = gsh_child.apply_child.apply

    if child.junior?
      term_amount = Settings.junior_term_amount
      year_amount = Settings.junior_year_amount
    elsif child.senior?
      term_amount = Settings.senior_term_amount
      year_amount = Settings.senior_year_amount
    end

    apply_num = 4 - child.child_grade_integer
    byebug
    year = Time.now.year

    GshChildGrant.find_or_create_by(title: "#{year}学年春季学期", gsh_child: gsh_child, apply: apply, amount: term_amount, school_id: gsh_child.school_id) && apply_num -= 1 if child.next_term? && apply_num > 0

    if (apply_num > 0)
      apply_num.times do
        GshChildGrant.find_or_create_by(title: "#{year}秋季学期 - #{year + 1}学年春季学期", gsh_child: gsh_child, apply: apply, amount: year_amount, school_id: gsh_child.school_id)
        year += 1
      end
    end

    # child.semester

  end

end
