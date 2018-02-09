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
#  state      :integer          default(1)            # 显示状态：1:显示 2:隐藏
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Workplace < ApplicationRecord

  has_many :tasks

  enum state: {show: 1, hidden: 2} # 状态：1:显示 2:隐藏

  scope :sorted, ->{ order(created_at: :desc) }

  def save_and_gen_title
    self.title = self.full_address
    self.save
  end

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

end
