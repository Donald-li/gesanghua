# == Schema Information
#
# Table name: teams # 小组
#
#  id                    :integer          not null, primary key
#  name                  :string                                 # 名称
#  member_count          :integer                                # 会员数
#  current_donate_amount :decimal(14, 2)   default(0.0)          # 当前捐助金额
#  total_donate_amount   :decimal(14, 2)   default(0.0)          # 捐助总额
#  creater_id            :integer                                # 团队创建人id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_no               :string                                 # 团队编号
#

class Team < ApplicationRecord
  belongs_to :creater, class_name: 'User'

  has_many :users
  has_many :donate_records

  scope :sorted, ->{ order(created_at: :desc) }

  before_create :gen_team_no

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
    end.attributes!
  end

  private
  def gen_team_no
    self.team_no ||= Sequence.get_seq(kind: :team_no, prefix: 'T', length: 6)
  end

end
