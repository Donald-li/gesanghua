require 'rails_helper'

RSpec.describe "Api::V1::GshPlus::Volunteer", type: :request do

  let!(:login_user) { create(:user) }
  let!(:major1) { create(:major) }
  let!(:major2) { create(:major) }

  describe '格桑花+志愿者' do
    it '志愿者申请' do
      post api_v1_gsh_plus_volunteers_path,
           params: {
               volunteer: {name: '林则徐', IdCard: '110229190001010913', phone: '18888888888', describe: '屋里哇啦'},
               majorIds: [major1.id, major2.id]
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data]).to eq true

      get volunteer_apply_api_v1_gsh_plus_volunteers_path, headers: api_v1_headers(login_user)
      api_v1_expect_success

      get volunteer_info_api_v1_gsh_plus_volunteers_path, headers: api_v1_headers(login_user)
      api_v1_expect_success

      get edit_volunteer_api_v1_gsh_plus_volunteers_path, headers: api_v1_headers(login_user)
      api_v1_expect_success

      post update_volunteer_api_v1_gsh_plus_volunteers_path,
           params: {
               volunteer: {user_name: '林则徐', user_qq: '11022919', user_phone: '18888888889', describe: '屋里哇啦', workstation: '中科院'}
           }, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取专业技能' do
      get majors_api_v1_gsh_plus_volunteers_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end

end
