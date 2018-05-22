require 'rails_helper'

RSpec.describe "Api::V1::Donations", type: :request do

  before(:all) do
    @user = create(:user, balance: 0)
    @donor = create(:user, balance: 0)
    @promoter = create(:user)
    @source = create(:income_source, kind: 1)
    @pair_project = Project.pair_project
    @read_project = Project.read_project
    @radio_project = Project.radio_project
    @pair_season = create(:project_season, project: @pair_project)
    @read_season = create(:project_season, project: @read_project)
    @radio_season = create(:project_season, project: @radio_project)
    @school = create(:school, user: @user)
    @fund_category = create(:fund_category)
    @fund = create(:fund, fund_category: @fund_category)
    @donate_item = create(:donate_item, fund: @fund)
    @income_record = create(:income_record, fund: @fund, amount: 1000, balance: 1000, donor: @user)
    @radio_apply = create(:project_season_apply, project: @radio_project, season: @radio_season, school: @school, target_amount: 10000, present_amount: 0)

    @pair_apply = create(:project_season_apply, project: @pair_project, season: @pair_season, school: @school, target_amount: 6300, present_amount: 0)
    @read_apply = create(:project_season_apply, project: @read_project, season: @read_season, school: @school, bookshelf_type: 'whole', target_amount: 10500, present_amount: 0)
    @bookshelf1 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf2 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf3 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf4 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @bookshelf5 = create(:project_season_apply_bookshelf, project: @read_project, season: @read_season, school: @school, apply: @read_apply, target_amount: 2100, present_amount: 0)
    @child = create(:project_season_apply_child, project: @pair_project, season: @pair_season, school: @school, apply: @pair_apply)
  end

  describe '捐助' do

    it '捐捐助项' do
      post api_v1_donations_path(donate_way: 'wechat', donor: @donor.id, amount: 100, donate_item: @donate_item.id), headers: api_v1_headers(@user)
      api_v1_expect_success
      expect(json_body[:data][:pay_state]) == 'unpaid'
    end

    it "捐申请" do
      post api_v1_donations_path(donate_way: 'wechat', donor: @donor.id, amount: 100, apply: @read_apply.id), headers: api_v1_headers(@user)
      api_v1_expect_success
    end

    it "捐孩子" do
      post api_v1_donations_path(donate_way: 'wechat', donor: @donor.id, amount: 100, child: @child.id), headers: api_v1_headers(@user)
      api_v1_expect_success
    end

    it "捐已制定优先捐助人的孩子" do
      @child.update(priority_id: @user.id)
      post api_v1_donations_path(donate_way: 'wechat', donor: @donor.id, amount: 100, child: @child.id), headers: api_v1_headers(@user)
      api_v1_expect_error
    end

    it "捐书架" do
      post api_v1_donations_path(donate_way: 'wechat', donor: @donor.id, amount: 100, bookshelf: @bookshelf1.id), headers: api_v1_headers(@user)
      api_v1_expect_success
    end

    it '使用用户余额捐捐助项' do
      user = create(:user, balance: 500)
      post api_v1_donations_path(donate_way: 'balance', donor: @donor.id, amount: 100, donate_item: @donate_item.id), headers: api_v1_headers(user)
      api_v1_expect_success
      expect(json_body[:data][:pay_state]) == 'paid'
      expect(user.reload.balance.to_f).to eq 400
    end

  end

end
