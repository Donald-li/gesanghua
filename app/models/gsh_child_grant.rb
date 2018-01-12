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
#

class GshChildGrant < ApplicationRecord

  belongs_to :gsh_child
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id'

  enum state: {waiting: 1, granted: 2, suspend: 3, cancel: 4}
  default_value_for :state, 1

  enum donate_state: {pending: 1, succeed: 2} # 捐助状态：1:未筹款 2:已筹款
  default_value_for :donate_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def self.gen_grant_record(gsh_child)
    child = gsh_child.apply_child
    apply = gsh_child.apply_child.project_season_apply
    season = apply.season

    if child.junior?
      term_amount = Settings.junior_term_amount
      year_amount = Settings.junior_year_amount
    elsif child.senior?
      term_amount = Settings.senior_term_amount
      year_amount = Settings.senior_year_amount
    end

    if child.last_term?
      apply_num = 4 - child.grade.to_i
    else
      apply_num = 3 - child.grade.to_i
    end


    GshChildGrant.find_or_create_by(gsh_child: gsh_child, apply: apply, amount: term_amount) && apply_num -= 1 if child.last_term? && apply_num > 0

    if (apply_num > 0)
      apply_num.times do
        GshChildGrant.find_or_create_by(gsh_child: gsh_child, apply: apply, amount: year_amount)
      end
    end

    # child.semester

  end

end
