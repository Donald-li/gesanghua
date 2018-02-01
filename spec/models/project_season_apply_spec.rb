# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度的id
#  school_id         :integer                                # 关联学校id
#  teacher_id        :integer                                # 负责项目的老师id
#  describe          :text                                   # 描述、申请要求
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  state             :integer          default("show")       # 状态：1:展示 2:隐藏
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  bookshelf_type    :integer                                # 悦读项目申请类型
#  contact_name      :string                                 # 联系人姓名
#  contact_phone     :string                                 # 联系人电话
#  audit_state       :integer                                # 审核状态
#  abstract          :string                                 # 简述
#  address           :string                                 # 详细地址
#  apply_no          :string                                 # 项目申请编号
#  girl_number       :integer                                # 申请女生人数
#  boy_number        :integer                                # 申请男生人数
#  consignee         :string                                 # 收货人
#  consignee_phone   :string                                 # 收货人联系电话
#  target_amount     :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  execute_state     :integer          default("default")    # 执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成
#  project_type      :integer          default("apply")      # 项目类型:1:申请 2:筹款项目
#  class_number      :integer                                # 申请班级数
#  student_number    :integer                                # 受益学生数
#  project_describe  :text                                   # 项目介绍
#

require 'rails_helper'

RSpec.describe ProjectSeasonApply, type: :model do
  before(:all) do
    @user = create(:user)
    @source = create(:income_source, kind: 2)
    @project = create(:project)
    @project_season = create(:project_season, project_id: @project.id)
    @school = create(:school, user: @user)
    @fund_category = create(:fund_category)
    @fund = create(:fund, fund_category: @fund_category)
    @project_season_apply = create(:project_season_apply, project_id: @project.id, project_season_id: @project_season.id, school: @school)
    @child = create(:project_season_apply_child, project: @project, season: @project_season, apply: @project_season_apply, school: @school, semester: 'next_term')
    @child.approve_pass
    @grant = @child.gsh_child.gsh_child_grants.first
  end

  describe '测试配捐方法' do
    it '测试线下配捐给指定申请方法' do
      amount = 500
      params = {donate_way: 'offline', source_id: @source.id, user_id: @user.id, match_fund_id: nil, balance_id: @user.id}
      @project_season_apply.match_donate(params, amount, nil)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试使用其他资金配捐给指定申请方法(资金余额不足会退回)' do
      amount = 500
      params = {donate_way: 'match', match_fund_id: @fund.id}
      expect(@project_season_apply.match_donate(params, amount, nil)).to eq false
    end

    it '测试使用其他资金配捐给指定申请方法(资金余额充足)' do
      @fund.update(amount: 1000)
      amount = 500
      params = {donate_way: 'match', match_fund_id: @fund.id}
      @project_season_apply.match_donate(params, amount, nil)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试用户余额配捐给指定申请方法(余额不足会退回)' do
      amount = 500
      params = {donate_way: 'balance', balance_id: @user.id}
      expect(@project_season_apply.match_donate(params, amount, nil)).to eq false
    end

    it '测试用户余额配捐给指定申请方法(余额充足)' do
      @user.update(balance: 1000)
      amount = 500
      params = {donate_way: 'balance', balance_id: @user.id}
      @project_season_apply.match_donate(params, amount, nil)
      expect(@project_season_apply.donate_records.last.amount).to eq 500
    end

    it '测试线下配捐给指定孩子方法' do
      amount = @grant.amount
      params = {donate_way: 'offline', source_id: @source.id, user_id: @user.id}
      @project_season_apply.match_donate(params, amount, @child.id)
      expect(@child.donates.last.amount).to eq amount
    end

    it '测试使用其他资金配捐给指定孩子方法(资金不足)' do
      @fund.update(amount: 0)
      amount = @grant.amount
      params = {donate_way: 'match', match_fund_id: @fund.id}
      expect(@project_season_apply.match_donate(params, amount, @child.id)).to eq false
    end

    it '测试使用其他资金给指定孩子方法(资金充足)' do
      @fund.update(amount: 3000)
      amount = @grant.amount
      params = {donate_way: 'match', match_fund_id: @fund.id}
      @project_season_apply.match_donate(params, amount, @child.id)
      expect(@child.donates.last.amount).to eq amount
    end

    it '测试用户余额配捐给指定孩子方法(余额不足)' do
      @user.update(balance: 0)
      amount = @grant.amount
      params = {donate_way: 'balance', balance_id: @user.id}
      expect(@project_season_apply.match_donate(params, amount, @child.id)).to eq false
    end

    it '测试用户余额给指定孩子方法(余额充足)' do
      @user.update(balance: 3000)
      amount = @grant.amount
      params = {donate_way: 'balance', balance_id: @user.id}
      @project_season_apply.match_donate(params, amount, @child.id)
      expect(@child.donates.last.amount).to eq amount
    end

  end

end
