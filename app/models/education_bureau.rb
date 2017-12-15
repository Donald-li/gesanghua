# == Schema Information
#
# Table name: education_bureaus # 教育局表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  address    :string                                 # 详细地址
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EducationBureau < ApplicationRecord
end
