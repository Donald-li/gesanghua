# == Schema Information
#
# Table name: bookshelf_supplements
#
#  id                                :integer          not null, primary key
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
#

class BookshelfSupplement < ApplicationRecord

  validates :loss, :supply, presence: true

  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true

  has_many :donates, class_name: 'DonateRecord', dependent: :destroy
  has_one :receive, as: :owner

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {pending: 1, complete: 2, non_execution: 3, non_reception: 4, non_feedback: 5, done: 6}
  default_value_for :state, 1

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  scope :pass_done, ->{ pass.done }

  scope :sorted, ->{ order(created_at: :desc) }

end
