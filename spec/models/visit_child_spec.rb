# == Schema Information
#
# Table name: visit_children # 家访记录学生表
#
#  id         :bigint(8)        not null, primary key
#  visit_id   :integer                                # 家访ID
#  child_id   :integer                                # 孩子ID
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe VisitChild, type: :model do
  
end
