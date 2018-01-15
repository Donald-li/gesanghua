require 'axlsx'
class ExcelOutput

  def self.school_output
    p = Axlsx::Package.new
    wb = p.workbook
    schools = School.all.sorted
    wb.add_worksheet(:name => "表") do |sheet|
      sheet.add_row ["学校名称", "申请时间", "所在地区", "负责人", "联系电话", "学校类型"]
      schools.each do |school|
        sheet.add_row [school.name,
                       school.created_at.strftime("%Y-%m-%d %H:%M"),
                       school.full_address,
                       school.contact_name,
                       school.contact_phone,
                       school.enum_name(:kind)]
      end
    end
    p.serialize "public/files/学校" + DateTime.now.strftime("%Y-%m-%d-%s") + ".xlsx"
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

end