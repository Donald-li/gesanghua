# == Schema Information
#
# Table name: education_bureau_employees # 教育局工作人员表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 姓名
#  phone      :string                                 # 联系方式
#  nickname   :string                                 # 昵称
#  kind       :integer          default(1)            # 类型，1：员工 2：局长
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EducationBureauEmployee < ApplicationRecord
end
