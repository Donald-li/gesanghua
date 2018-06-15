# == Schema Information
#
# Table name: donate_items # 可捐助项目表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  describe   :string                                 # 说明
#  state      :integer                                # 状态： 1：显示 2：隐藏
#  position   :integer                                # 排序
#  fund_id    :integer                                # 基金id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 直接捐款到财务分类的可捐款项
class DonateItem < ApplicationRecord

  belongs_to :fund
  has_many :donate_records, dependent: :restrict_with_error
  has_many :amount_tabs, dependent: :destroy
  has_one :project

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }


  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏
  default_value_for :state, 1

  # 使用捐助
  def accept_donate(donate_records)
    donate_records.each do |donate_record|
      self.fund.balance += donate_record.amount
    end
    self.save!
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.value self.id
      json.project_name self.project.try(:alias)
      json.describe self.describe
      if self.amount_tabs.present?
        json.amount_tabs self.amount_tabs.show.sorted.map {|t| t.summary_builder}
      else
        json.amount_tabs do
          json.array! Settings.amount_tabs do |amount_tab|
            json.id amount_tab
            json.amount amount_tab
            json.alias ''
          end
        end
      end
    end.attributes!
  end

end
