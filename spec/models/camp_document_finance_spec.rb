# == Schema Information
#
# Table name: camp_document_finances # 拓展营预决算表
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  budge                   :decimal(14, 2)   default(0.0)          # 预算
#  amount                  :decimal(14, 2)   default(0.0)          # 决算
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

require 'rails_helper'

RSpec.describe CampDocumentFinance, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
