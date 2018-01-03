# == Schema Information
#
# Table name: audits
#
#  id         :integer          not null, primary key
#  owner_type :string
#  owner_id   :integer
#  user_id    :integer                                # 审核人
#  comment    :text                                   # 评语
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Audit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
