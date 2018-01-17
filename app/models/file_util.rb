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

end