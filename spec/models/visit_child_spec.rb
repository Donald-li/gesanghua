# == Schema Information
#
# Table name: visit_children # 家访记录学生表
#
#  id                        :integer          not null, primary key
#  visit_id                  :integer                                # 家访记录ID
#  project_apply_children_id :integer                                # 家访孩子ID
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'rails_helper'

RSpec.describe VisitChild, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
