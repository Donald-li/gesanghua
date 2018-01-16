require 'axlsx'
class ExcelOutput

  def self.school_output
    p = Axlsx::Package.new
    wb = p.workbook
    schools = School.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["学校名称", "申请时间", "所在地区", "负责人", "联系电话"]
      schools.each do |school|
        sheet.add_row [school.name,
                       school.created_at.strftime("%Y-%m-%d %H:%M"),
                       school.full_address,
                       school.contact_name,
                       school.contact_phone]
      end
    end
    p.serialize "public/files/学校" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
  end

  def self.donate_statistics_output
    p = Axlsx::Package.new
    wb = p.workbook
    users = User.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["用户ID", "昵称", "姓名", "手机号码", "捐助金额", "线上捐助", "线下捐助"]
      users.each do |user|
        sheet.add_row [user.id,
                       user.nickname,
                       user.name,
                      user.phone,
                      user.donate_count,
                      user.online_count,
                      user.offline_count]
      end
    end
    p.serialize "public/files/用户捐助统计" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
  end

  # def self.pair_grants_output
  #   p = Axlsx::Package.new
  #   wb = p.workbook
  #   grants = GshChildGrant.sorted
  #   wb.add_worksheet(:name => "表") do |sheet|
  #     sheet.add_row ["编号", "姓名", "年龄", "发放日期", "学校", "发放说明", "发放金额", "筹款状态", "发放状态"]
  #     grants.each do |grant|
  #       sheet.add_row [grant.grant_no,
  #                      grant.try(:gsh_child).try(:name),
  #                      grant.try(:gsh_child).try(:age),
  #                      (grant.granted_at.strftime("%Y-%m-%d %H:%M") if grant.granted_at),
  #                      grant.try(:school).try(:name),
  #                      grant.grant_remark,
  #                      grant.amount,
  #                      grant.enum_name(:donate_state),
  #                      grant.enum_name(:state)]
  #     end
  #   end
  #   p.serialize "public/files/结对发放" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
  # end

  def self.campaign_enlist_output(campaign)
    p = Axlsx::Package.new
    wb = p.workbook
    campaign_enlists = campaign.campaign_enlists.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      if campaign.price == 0
        sheet.add_row ["报名用户", "用户昵称", "报名时间", "报名人数", "联系人", "联系电话"]
        campaign_enlists.each do |campaign_enlist|
          sheet.add_row [campaign_enlist.user.try(:phone),
                         campaign_enlist.user.try(:nickname),
                         campaign_enlist.created_at.strftime("%Y-%m-%d %H:%M"),
                         campaign_enlist.number,
                         campaign_enlist.contact_name,
                         campaign_enlist.contact_phone]
        end
      else
        sheet.add_row ["报名用户", "用户昵称", "报名时间", "报名人数", "联系人", "联系电话", "金额", "支付状态"]
        campaign_enlists.each do |campaign_enlist|
          sheet.add_row [campaign_enlist.user.try(:phone),
                         campaign_enlist.user.try(:nickname),
                         campaign_enlist.created_at.strftime("%Y-%m-%d %H:%M"),
                         campaign_enlist.number,
                         campaign_enlist.contact_name,
                         campaign_enlist.contact_phone,
                         campaign_enlist.total,
                         campaign_enlist.enum_name(:payment_state)]
        end
      end
    p.serialize "public/files/活动" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
  end
end

end
