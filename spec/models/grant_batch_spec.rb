# == Schema Information
#
# Table name: grant_batches # 发放批次
#
#  id          :bigint(8)        not null, primary key
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
  let(:batch){ create(:grant_batch, project: Project.pair_project)}

  it '自动生成批次号' do
    expect(batch.batch_no).not_to be(nil)
  end

  it '默认是结对项目' do
    expect(batch.project_id).to eq(Project.pair_project.try(:id))
  end
end
