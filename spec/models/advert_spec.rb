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
