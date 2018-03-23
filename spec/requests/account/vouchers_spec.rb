require 'rails_helper'

RSpec.describe "Api::V1::Account::Vouchers", type: :request do

  let!(:login_user) {create(:user)}
  let!(:school) {create(:school)}
  let!(:teacher) {create(:teacher, school: school, user: login_user)}
  let!(:project) {create(:project)}
  let!(:season) {create(:project_season, project: project)}
  let!(:apply) {create(:project_season_apply, project: project, season: season, teacher: teacher)}
  let!(:child) {create(:project_season_apply_child, project: project, season: season, apply: apply, school: school)}
  let!(:record1) {create(:donate_record, project: project, season: season, apply: apply, user: login_user, appoint: child, pay_state: 'paid', amount: '2000' )}

  describe '测试开票' do
    it '提交开票申请' do
      post apply_voucher_api_v1_account_vouchers_path,
          params: {voucher: {kind: 'company', tax_company: '阿里巴巴',
                             amount: record1.amount, province: '630000', city: '630100', district: '630123',
                             address: '某街道', contact_name: '某人', contact_phone: '17666666666'},
          checked_records: [record1.id]},
          headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取开票申请列表和详情' do
      post apply_voucher_api_v1_account_vouchers_path,
           params: {voucher: {kind: 'company', tax_company: '阿里巴巴',
                              amount: record1.amount, province: '630000', city: '630100', district: '630123',
                              address: '某街道', contact_name: '某人', contact_phone: '17666666666'},
                    checked_records: [record1.id]},
           headers: api_v1_headers(login_user)
      api_v1_expect_success

      get api_v1_account_vouchers_path, headers: api_v1_headers(login_user)
      api_v1_expect_success

      get api_v1_account_voucher_path(id: record1.reload.voucher_id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end

end
