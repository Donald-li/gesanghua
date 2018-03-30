# == Schema Information
#
# Table name: camp_document_summaries # 拓展营总结
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  free_resource           :string                                 # 本营免费资源
#  resource_value          :decimal(14, 2)   default(0.0)          # 免费资源价值
#  donate_amount           :decimal(14, 2)   default(0.0)          # 本营筹款多少
#  publicize_count         :integer                                # 本营宣传次数
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

require 'rails_helper'

RSpec.describe CampDocumentSummary, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
