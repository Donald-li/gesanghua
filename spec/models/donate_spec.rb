require 'rails_helper'

RSpec.describe Donate, type: :model do



  describe '测试捐赠编号和捐赠证书生成方法' do
    before(:each) do
      DonateRecord.donate_gsh(user, 3000)
    end
    it '测试捐赠编号方法' do
      record = DonateRecord.first
      record.pay_and_gen_certificate
      expect(record.paid?).to eq true
      expect(record.certificate_no.present?).to eq true
    end

    it '测试捐赠证书' do
      record = DonateRecord.first
      expect(record.donor_certificate_path).to eq "/images/certificates/#{record.created_at.strftime('%Y%m%d')}/#{record.id}/#{Encryption.md5(record.id.to_s)}.jpg"
    end
  end

  describe "测试劝捐和团队捐款" do
    it '有代捐人的捐款' do

    end

    it '有劝捐人' do
    end

    it '有团队的捐款' do
    end

  end

end
