# == Schema Information
#
# Table name: adverts # 广告表
#
#  id            :bigint(8)        not null, primary key
#  kind          :integer                                # 分类
#  title         :string                                 # 标题
#  description   :string                                 # 描述
#  url           :string                                 # 链接
#  views_count   :integer                                # 展示次数
#  kind_position :integer                                # 分类排序
#  state         :integer                                # 状态
#  user_id       :integer                                # 用户id
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Advert, type: :model do
  let(:advert) { build(:advert) }

  it { should validate_presence_of :kind }

  it '测试广告基本操作' do
    advert.title = 'guangao'
    advert.save
    expect(advert.valid?).to be true
    expect(advert.title).to eq 'guangao'

  end
end
