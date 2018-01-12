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

end
