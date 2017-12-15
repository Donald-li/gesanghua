# == Schema Information
#
# Table name: campaign_categories # 活动分类表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CampaignCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
