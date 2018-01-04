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

require 'rails_helper'

RSpec.describe SpecialAdvert, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
