# == Schema Information
#
# Table name: visits # 家访记录表
#
#  id             :integer          not null, primary key
#  owner_id       :integer
#  owner_type     :string
#  content        :text                                   # 内容
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  apply_child_id :integer                                # 孩子申请ID
#

require 'rails_helper'

RSpec.describe Visit, type: :model do
  
end
