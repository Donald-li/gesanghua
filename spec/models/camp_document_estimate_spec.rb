# == Schema Information
#
# Table name: camp_document_estimates # 拓展营概算表
#
#  id                      :bigint(8)        not null, primary key
#  user_id                 :integer                                # 用户
#  item                    :string                                 # 项
#  amount                  :decimal(14, 2)   default(0.0)          # 金额
#  remark                  :string                                 # 备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

require 'rails_helper'

RSpec.describe CampDocumentEstimate, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
