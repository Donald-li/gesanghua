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

FactoryBot.define do
  factory :workplace do
    province '630000'
    city '630100'
    district '630123'
    address '平安路11号'
    describe {FFaker::LoremCN.sentence}
    state 1
  end
end
