# == Schema Information
#
# Table name: majors # 登记
#
#  id         :integer          not null, primary key
#  name       :string                                 # 标题
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Major < ApplicationRecord
end
