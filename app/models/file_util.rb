# -*- encoding : utf-8 -*-
require 'roo'

class FileUtil

#   def self.import_students(original_filename: nil, path: nil, project_apply_id: nil, school_id: nil)
#     apply = ProjectApply.find(project_apply_id)
#     if apply.students.destroy_all
#       s = nil
#       if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
#         s = Roo::Excelx.new path
#       else
#         return
#       end
#       2.upto(s.last_row) do |line|
#
#         number = s.formatted_value(line, 'A')
#         name = s.formatted_value(line, 'B')
#         age = s.formatted_value(line, 'C')
#         genre = s.formatted_value(line, 'D')
#         cloth_type = s.formatted_value(line, 'E')
#         cloth_size = s.formatted_value(line, 'F')
#         shoes_type = s.formatted_value(line, 'G')
#         shoes_size = s.formatted_value(line, 'H')
#         parent_name = s.formatted_value(line, 'I')
#         parent_phone = s.formatted_value(line, 'J')
#         address = s.formatted_value(line, 'K')
#
#         if genre == '男'
#           genre = 1
#         elsif genre == '女'
#           genre = 2
#         else
#           genre = nil
#         end
#         if cloth_type == '女童装'
#           cloth_type = 0
#         elsif cloth_type == '男童装'
#           cloth_type = 1
#         elsif cloth_type == '成人男装'
#           cloth_type = 2
#         elsif cloth_type == '成人女装'
#           cloth_type = 3
#         else
#           cloth_type = nil
#         end
#
#         if shoes_type == '女童鞋'
#           shoes_type = 0
#         elsif shoes_type == '男童鞋'
#           shoes_type = 1
#         elsif shoes_type == '成人男鞋'
#           shoes_type = 2
#         elsif shoes_type == '成人女鞋'
#           shoes_type = 3
#         else
#           shoes_type = nil
#         end
#
#         if Student.find_by(number: number).present?
#           return {message: "学生名单第#{line}行，学籍编号#{number}已存在，请检查修改"}
#         end
#
#         if name.nil?
#           return {status: false, message: "学生名单第#{line}行，学生姓名填写错误，请检查修改"}
#         end
#
#         if age.nil?
#           return {status: false, message: "学生名单第#{line}行，学生年龄填写错误，请检查修改"}
#         end
#
#         if genre.nil?
#           return {status: false, message: "学生名单第#{line}行，学生性别填写错误，请检查修改"}
#         end
#
#         if cloth_type.nil? && shoes_type.nil?
#           return {status: false, message: "学生名单第#{line}行，需要选择一种申请物品类型，请检查修改"}
#         end
#
#         if cloth_size.nil? && shoes_size.nil?
#           return {status: false, message: "学生名单第#{line}行，需要填写申请物品的型号，请检查修改"}
#         end
#
#         # if parent_name.nil?
#         #   return {status: false, message: "学生名单第#{line}行，家长姓名填写错误，请检查修改"}
#         # end
#         #
#         # if parent_phone.nil?
#         #   return {status: false, message: "学生名单第#{line}行，家长联系方式填写错误，请检查修改"}
#         # end
#
#         if address.nil?
#           return {status: false, message: "学生名单第#{line}行，家庭住址填写错误，请检查修改"}
#         end
#
#         Student.create(number: number, name: name, age: age, genre: genre.to_i, cloth_type: cloth_type, cloth_size: cloth_size, shoes_type: shoes_type, shoes_size: shoes_size, parent_name: parent_name, parent_phone: parent_phone, address: address, project_apply_id: project_apply_id, school_id: school_id)
#
#       end
#       if apply.students.count == 0
#         return {status: false, message: "学生名单为空"}
#       end
#       return {status: true, message: "上传成功"}
#     end
#   end
#
#   def self.import_schools(original_filename: nil, path: nil)
#     s = nil
#     if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
#       s = Roo::Excelx.new path
#     else
#       return
#     end
# #  name：学校名称  contact_name：联系人姓名 contact_title：联系人职位 contact_phone：联系方式 province：省 city：市 district：区 street：街 address：详细地址
#     2.upto(s.last_row) do |line|
#
#       name = s.formatted_value(line, 'A')
#       contact_name = s.formatted_value(line, 'B')
#       contact_title = s.formatted_value(line, 'C')
#       contact_phone = s.formatted_value(line, 'D')
#       province = s.formatted_value(line, 'E')
#       city = s.formatted_value(line, 'F')
#       district = s.formatted_value(line, 'G')
#       address = s.formatted_value(line, 'H')
#       information = s.formatted_value(line, 'I')
#
#       SchoolLibrary.find_or_create_by(name: name, contact_name: contact_name, contact_title: contact_title, contact_phone: contact_phone, province: province, city: city, district: district, address: address, information: information, state: 3)
#
#     end
#   end

    def self.import_income_records(original_filename: nil, path: nil)
      s = nil
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
      end

      2.upto(s.last_row) do |line|

        fund_title = s.formatted_value(line, 'A')
        income_time = s.cell(line, 'B')
        amount = s.formatted_value(line, 'C')
        income_source_name = s.formatted_value(line, 'D')
        donor = s.formatted_value(line, 'E')
        donor_phone = s.formatted_value(line, 'F')
        user_name = s.formatted_value(line, 'G')
        remitter_name = s.formatted_value(line, 'H')
        remark = s.formatted_value(line, 'I')

        fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil
        income_source = IncomeSource.find_by(name: income_source_name) || nil

        user = User.find_by(phone: donor_phone)

        if fund.present?
          income_time = income_time.class.to_s == 'DateTime' || income_time.class.to_s == 'Date' ? income_time : Time.parse(income_time)
          IncomeRecord.create(fund: fund, income_time: income_time, amount: amount, income_source: income_source, user: user, donor: donor, remitter_name: remitter_name, remark: remark)
        end

      end
    end

    def self.import_expenditure_records(original_filename: nil, path: nil)
      s = nil
      s_count = 0
      f_count = 0
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
      end
      #  name：学校名称  contact_name：联系人姓名 contact_title：联系人职位 contact_phone：联系方式 province：省 city：市 district：区 street：街 address：详细地址
      2.upto(s.last_row) do |line|

        name = s.formatted_value(line, 'A')
        expended_at = s.cell(line, 'B')
        fund_title = s.formatted_value(line, 'C')
        amount = s.formatted_value(line, 'D')
        remark = s.formatted_value(line, 'E')
        operator = s.formatted_value(line, 'F')

        fund = fund_title.present? ? FundCategory.find_by(name: fund_title.split('-').first).funds.find_by(name: fund_title.split('-').second) : nil

        if fund.present?
          expended_at = expended_at.class.to_s == 'DateTime' || expended_at.class.to_s == 'Date' ? expended_at : Time.parse(expended_at)
          ExpenditureRecord.create(fund: fund, expended_at: expended_at, amount: amount, operator: operator, name: name, remark: remark)
          s_count += 1
        else
          f_count += 1
        end
      end
      # right_notice = "成功录入#{s_count}条，其中#{f_count}条录入失败"
      right_notice = "成功录入#{s_count}条支出记录"
    end

    def self.import_beneficial_children_records(original_filename: nil, path: nil, apply_id: nil, project_season_apply_bookshelf_id: nil)
      s = nil
      if File.extname(original_filename) == '.xlsx' || File.extname(original_filename) == '.xls'
        s = Roo::Excelx.new path
      else
        return
      end

      @apply = ProjectSeasonApply.find(apply_id)

      2.upto(s.last_row) do |line|

        name = s.formatted_value(line, 'A')
        gender = s.cell(line, 'B')
        id_no = s.formatted_value(line, 'C')
        nation = s.formatted_value(line, 'D')

        if gender == '男'
          gender = 1
        elsif gender == '女'
          gender = 2
        else
          gender = ''
        end

        nation = BeneficialChild.nation_hash_name(nation)

        BeneficialChild.create(project_season_apply: @apply, project_season_apply_bookshelf_id: project_season_apply_bookshelf_id, name: name, gender: gender, id_no: id_no, nation: nation)
      end
    end

end
