require 'rails_helper'

RSpec.describe "Api::V1::PairChildren", type: :request do

  let!(:login_user) { create(:user) }
  let!(:pair) { create(:project) }
  let!(:season) { create(:project_season, project: pair) }
  let!(:apply) { create(:project_season_apply, season: season, project: pair) }
  let!(:school) { create(:school) }
  let!(:child1) { create(:project_season_apply_child, state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school) }
  let!(:child2) { create(:project_season_apply_child, name: '陈同学',district: '630121', state: 1, approve_state: 2, kind: 1, project: pair, season: season, apply: apply, school: school) }

  describe '测试获得孩子信息' do
    it '获取孩子信息' do
      child1.approve_pass
      get api_v1_pair_child_path(id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:id]).to eq child1.id
    end
  end

  describe '测试举报' do
    it '举报孩子' do
      post complaint_api_v1_pair_children_path,
          params: {id: child1.id,
                   complaint: {contact_name: '刘某', contact_phone: '17866539878', content: '该孩子描述内容不实'},
                   images: {}},
          headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

  describe '捐助孩子' do
    it '获取捐助孩子信息' do
      get contribute_api_v1_pair_children_path(id: child1.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:child_info][:id]).to eq child1.id
    end
  end

  describe '捐助孩子支付' do
    it '下单支付' do
      child1.approve_pass
      post settlement_api_v1_pair_children_path,
           params: {id: child1.id, by_team: false,
                    donor_name: '好心人', total_amount: '2100',
                    paymethod: 'weixin', selectedGrants: child1.donate_record_builder},
           headers: api_v1_headers(login_user)
      api_v1_expect_success
      expect(json_body[:data][:record_state]).to eq true
    end
  end

  describe '获取审核通过的孩子列表' do
    it '获取孩子列表' do
      child1.approve_pass
      child2.approve_pass
      get verified_students_api_v1_cooperation_pairs_path(id: apply.id), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end
  end

end
