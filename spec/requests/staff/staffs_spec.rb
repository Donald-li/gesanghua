require 'rails_helper'

RSpec.describe "Api::V1::Staff::Staffs", type: :request do

  let!(:login_user) { create(:user) }
  let!(:volunteer1) {create(:volunteer, approve_state: 'pass')}
  let!(:volunteer2) {create(:volunteer, approve_state: 'pass')}

  describe '工作人员' do
    it '首页' do
      get api_v1_staff_staffs_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq false

      login_user.add_role(:project_manager)
      login_user.save

      get api_v1_staff_staffs_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
      expect(json_body[:data][:search_result][:id]).to eq login_user.id
    end

    it '志愿者列表' do
      get volunteer_list_api_v1_staff_staffs_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq false

      login_user.add_role(:project_manager)
      login_user.save

      get volunteer_list_api_v1_staff_staffs_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:result]).to eq true
      expect(json_body[:data][:search_result].count).to eq Volunteer.pass.count
    end

  end

end
