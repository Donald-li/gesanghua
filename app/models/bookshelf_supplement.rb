# == Schema Information
#
# Table name: bookshelf_supplements
#
#  id                                :bigint(8)        not null, primary key
#  project_season_apply_bookshelf_id :integer                                # 书架ID
#  project_season_apply_id           :integer                                # 申请ID
#  loss                              :integer                                # 损耗数量
#  state                             :integer                                # 审核状态
#  describe                          :text                                   # 描述
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  present_amount                    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  supply                            :integer                                # 补充数量
#  target_amount                     :decimal(14, 2)   default(0.0)          # 目标金额
#  audit_state                       :integer                                # 审核状态
#  show_state                        :integer                                # 显示状态
#  project_id                        :integer                                # 项目id
#  management_fee_state              :integer                                # 计提管理费状态
#

# 图书角书架补书
# TODO: 补书少了一个season_id
class BookshelfSupplement < ApplicationRecord
  has_paper_trail only: [:project_id, :project_season_apply_bookshelf_id, :project_season_apply_id, :loss, :state, :describe, :supply, :audit_state, :show_state,
    :target_amount, :present_amount]

  validates :loss, :supply, presence: true

  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :project
  default_value_for :project_id, 2 # 悦读项目

  has_many :donates, class_name: 'DonateRecord', as: :owner, dependent: :destroy
  has_one :receive_feedback, as: :owner
  has_one :install_feedback, as: :owner
  has_one :logistic, as: :owner

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {raising: 1, to_delivery: 2, to_receive: 3, to_feedback: 4, feedbacked: 5, done: 6, cancelled: 7}
  default_value_for :state, 1

  # 是否计提管理费
  enum management_fee_state: {unaccrue: 0, accrued: 2} # 状态：1:未计提 2:已计提
  default_value_for :management_fee_state, 0

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  scope :pass_done, ->{ where(state: ['feedbacked', 'done']) }

  scope :raise_complete, -> { where(state: ['to_delivery', 'to_receive', 'to_feedback', 'feedbacked', 'done'])}

  scope :sorted, ->{ order(created_at: :desc) }

  # 使用捐助
  def accept_donate(donate_records)
    donate_record = donate_records.last

    amount = [surplus_money, donate_record.amount].min
    donate_record.update!(amount: amount)

    self.present_amount += amount
    self.apply.present_amount += amount

    self.state = 'to_delivery' if self.present_amount >= self.target_amount
    self.save!
    self.apply.save!
  end

  def surplus_money
    self.target_amount - self.present_amount
  end

  # 统一显示名称
  def show_name
    self.bookshelf.try(:show_name)
  end

  #用于操作日志查找关系
  def project_season_apply_bookshelf
    self.bookshelf
  end

  def project_season_apply
    self.apply
  end

  def class_list_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :target_amount, :present_amount)
      json.bookshelf_no self.bookshelf.bookshelf_no
      json.apply_name self.apply.try(:name)
      json.title self.bookshelf.show_title
      json.state self.enum_name(:state)
    end.attributes!
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :supply, :target_amount, :present_amount, :state, :describe)
      json.state_name self.enum_name(:state)
      json.surplus_money self.surplus_money
      json.class_id [self.bookshelf.id.to_s]
      json.class_name self.bookshelf.classname
      json.loss self.loss
    end.attributes!
  end

  def self.clear_garbage
    self.where(project_season_apply_id: nil).destroy_all
  end

end
