# == Schema Information
#
# Table name: special_adverts
#
#  id         :bigint(8)        not null, primary key
#  special_id :integer                                # 专题id
#  advert_id  :integer                                # 广告id
#  position   :integer                                # 排序
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :integer                                # 类型
#

FactoryBot.define do
  factory :special_advert do
    special_id 1
    advert_id 1
    position 1
  end
end
