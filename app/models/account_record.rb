# == Schema Information
#
# Table name: account_records # 账户记录
#
#  id               :integer          not null, primary key
#  user_id          :integer                                # 用户ID
#  kind             :integer                                # 操作类型
#  income_record_id :integer
#  donate_record_id :integer
#  donor_id         :integer
#  amount           :decimal(14, 2)   default(0.0)          # 金额
#  remark           :text                                   # 备注
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  title            :string                                 # 标题
#

class AccountRecord < ApplicationRecord
  belongs_to :user
  belongs_to :donor, class_name: 'User', foreign_key: :donor_id, optional: true
  belongs_to :income_record, optional: true
  belongs_to :donate_record, optional: true

  enum kind: {adjust: 1, donate: 2, refund: 3, charge: 4} # 1:调整 2:捐助 3:退款 4:充值
  default_value_for :kind, 1

  counter_culture :user, column_name: 'balance', delta_magnitude: proc {|model| model.amount }

  scope :sorted, -> { order(created_at: :desc) }

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :amount)
      json.time self.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end.attributes!
  end

end
