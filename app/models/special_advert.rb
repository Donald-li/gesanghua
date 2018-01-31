# == Schema Information
#
# Table name: special_adverts
#
#  id         :integer          not null, primary key
#  special_id :integer                                # 专题id
#  advert_id  :integer                                # 广告id
#  position   :integer                                # 排序
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kind       :integer                                # 类型
#

class SpecialAdvert < ApplicationRecord
  belongs_to :special
  belongs_to :advert

  acts_as_list
  scope :sorted, ->{ order(position: :desc) }

  enum kind: {top: 1, down: 2}

end
