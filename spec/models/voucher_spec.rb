# == Schema Information
#
# Table name: vouchers # 捐助收据表
#
#  id            :integer          not null, primary key
#  user_id       :integer                                # 用户ID
#  amount        :decimal(14, 2)   default(0.0)          # 金额
#  state         :integer                                # 状态
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人电话
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  address       :string                                 # 详细地址
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kind          :integer                                # 开票类型
#  tax_no        :string                                 # 开票税号
#  voucher_no    :string                                 # 发票编号
#  tax_company   :string                                 # 开票单位
#

require 'rails_helper'

RSpec.describe Voucher, type: :model do

  before(:each) do
    @user = create(:user)
    @user2 = create(:user)
    @project = create(:project)
    @school = create(:school)
    @team = create(:team, creater_id: @user.id, manage_id: @user.id)
    @project_season = create(:project_season, project_id: @project.id)
    @project_season_apply = create(:project_season_apply, project_id: @project.id, project_season_id: @project_season.id)
    @project_season_apply_child = create(:project_season_apply_child, project_id: @project.id, project_season_id: @project_season.id, project_season_apply_id: @project_season_apply.id, school_id: @school.id)
    @voucher = create(:voucher, user_id: @user.id)
    @donate_record_1 = create(:donate_record, project_id: @project.id, project_season_id: @project_season.id, project_season_apply_id: @project_season_apply.id, project_season_apply_child_id: @project_season_apply_child.id, user_id: @user.id, promoter_id: @user2.id, team_id: @team.id )
    @donate_record_2 = create(:donate_record, project_id: @project.id, project_season_id: @project_season.id, project_season_apply_id: @project_season_apply.id, project_season_apply_child_id: @project_season_apply_child.id, user_id: @user.id, promoter_id: @user2.id, team_id: @team.id )
    @donate_record_3 = create(:donate_record, project_id: @project.id, project_season_id: @project_season.id, project_season_apply_id: @project_season_apply.id, project_season_apply_child_id: @project_season_apply_child.id, user_id: @user.id, promoter_id: @user2.id, team_id: @team.id )
  end

  it "测试提交发票信息是否同步更新捐赠记录" do
    donate_records = []
    donate_records << @donate_record_1
    donate_records << @donate_record_2
    donate_records << @donate_record_3
    ids = donate_records.map{ |i| i.id }
    expect(@voucher.save_voucher(ids)).to eq(true)
    expect(@voucher.voucher_no.present?).to eq true
  end

end
