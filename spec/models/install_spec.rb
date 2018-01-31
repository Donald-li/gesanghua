# == Schema Information
#
# Table name: feedbacks # 反馈表
#
#  id            :integer          not null, primary key
#  content       :text                                   # 内容
#  owner_type    :string
#  owner_id      :integer
#  type          :string                                 # 类型：receive、install、continual
#  state         :integer                                # 状态
#  approve_state :integer                                # 审核状态
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 反馈类型
#  user_id       :integer                                # 反馈人
#

require 'rails_helper'

RSpec.describe Install, type: :model do
  
end
