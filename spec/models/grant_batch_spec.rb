# == Schema Information
#
# Table name: grant_batches # 发放批次
#
#  id          :integer          not null, primary key
#  project_id  :integer                                # 所属项目
#  batch_no    :string                                 # 批次号
#  name        :string                                 # 名称
#  description :text                                   # 描述
#  state       :integer                                # 状态
#  user_id     :integer                                # 发放负责人
#  grant_at    :datetime                               # 发放时间
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe GrantBatch, type: :model do
  it '自动生成批次号' do
    batch = create(:grant_batch)
    expect(batch.batch_no).not_to be(nil)
  end
end
