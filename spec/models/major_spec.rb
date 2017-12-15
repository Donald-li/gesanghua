# == Schema Information
#
# Table name: majors # 专业表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 专业名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Major, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
