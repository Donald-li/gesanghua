# == Schema Information
#
# Table name: audits
#
#  id         :integer          not null, primary key
#  owner_type :string
#  owner_id   :integer
#  state      :integer                                # 审核状态 0:待审核 1:通过 2:未通过
#  user_id    :integer                                # 审核人
#  comment    :text                                   # 评语
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Audit, type: :model do
  
end
