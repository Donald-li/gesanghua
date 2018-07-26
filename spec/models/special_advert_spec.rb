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

require 'rails_helper'

RSpec.describe SpecialAdvert, type: :model do
  
end
