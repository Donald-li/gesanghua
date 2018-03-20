# == Schema Information
#
# Table name: workplaces # 任务地点
#
#  id         :integer          not null, primary key
#  title      :string                                 # 名称
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区县
#  address    :string                                 # 详细地址
#  describe   :text                                   # 描述
#  state      :integer          default("show")       # 显示状态：1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 志愿者任务地点
class Workplace < ApplicationRecord

  has_many :tasks

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  scope :sorted, ->{ order(created_at: :desc) }

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title)
    end.attributes!
  end

end
