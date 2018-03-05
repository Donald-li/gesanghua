# == Schema Information
#
# Table name: camp_document_finances # 拓展营预决算表
#
#  id         :integer          not null, primary key
#  project_id :integer                                # 项目
#  user_id    :integer                                # 用户
#  item       :string                                 # 项
#  budge      :decimal(14, 2)   default(0.0)          # 预算
#  amount     :decimal(14, 2)   default(0.0)          # 决算
#  remark     :string                                 # 备注
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CampDocumentFinance, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
