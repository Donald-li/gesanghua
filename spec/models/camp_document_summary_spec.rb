# == Schema Information
#
# Table name: camp_document_summaries # 拓展营总结
#
#  id                :integer          not null, primary key
#  project_season_id :integer                                # 项目
#  user_id           :integer                                # 用户
#  free_resource     :string                                 # 本营免费资源
#  resource_value    :decimal(14, 2)   default(0.0)          # 免费资源价值
#  donate_amount     :decimal(14, 2)   default(0.0)          # 本营筹款多少
#  publicize_count   :integer                                # 本营宣传次数
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe CampDocumentSummary, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end