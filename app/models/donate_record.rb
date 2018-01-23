# == Schema Information
#
# Table name: donate_records # 捐赠记录
#
#  id                            :integer          not null, primary key
#  user_id                       :integer                                # 用户id
#  appoint_type                  :string                                 # 指定类型
#  appoint_id                    :integer                                # 指定类型
#  fund_id                       :integer                                # 基金ID
#  pay_state                     :integer                                # 付款状态
#  amount                        :decimal(14, 2)   default(0.0)          # 捐助金额
#  project_id                    :integer                                # 项目id
#  team_id                       :integer                                # 小组id
#  message                       :string                                 # 留言
#  donor                         :string                                 # 捐赠者
#  promoter_id                   :integer                                # 劝捐人
#  remitter_name                 :string                                 # 汇款人姓名
#  remitter_id                   :integer                                # 汇款人id
#  voucher_state                 :integer                                # 捐赠收据状态
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  project_season_id             :integer                                # 年度ID
#  project_season_apply_id       :integer                                # 年度项目ID
#  project_season_apply_child_id :integer                                # 年度孩子申请ID
#  donate_no                     :string                                 # 捐赠编号
#  voucher_id                    :integer                                # 捐助记录ID
#  period                        :integer                                # 月捐期数
#  month_donate_id               :integer                                # 月捐id
#

class DonateRecord < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  belongs_to :promoter, class_name: 'User', optional: true
  # belongs_to :remitter, class_name: 'User'
  belongs_to :project, optional: true
  counter_culture :project, column_name: :donate_record_amount_count, delta_magnitude: proc {|model| model.amount}
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :team, optional: true
  belongs_to :project_season_apply_child, optional: true
  has_one :income_record, dependent: :destroy
  belongs_to :voucher, optional: true
  belongs_to :month_donate, optional: true
  belongs_to :fund, optional: true
  belongs_to :appoint, polymorphic: true, optional: true

  # has_many :voucher_donate_records
  # has_many :vouchers, through: :voucher_donate_records
  # appoint_type 多态关联
  # belongs_to :user, polymorphic: true

  validates :amount, :donor, :remitter_name, presence: true

  enum pay_state: { unpay: 1, paid: 2 } #付款状态， 1:已付款  2:未付款
  default_value_for :pay_state, 1

  enum voucher_state: {to_bill: 1, billed: 2 } #收据状态，1:未开票 2:已开票
  default_value_for :voucher_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.user_name self.user.present? ? self.user.name : '爱心人士'
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
      json.amount number_to_currency(self.amount)
      json.item_name self.appoint.present? ? self.appoint.name : ''
      json.team self.team.present? ? self.team.name : ''
      json.project self.try(:project).try(:name)
    end.attributes!
  end

end
