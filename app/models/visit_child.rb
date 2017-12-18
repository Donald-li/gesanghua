# == Schema Information
#
# Table name: visit_children # 家访记录学生表
#
#  id         :integer          not null, primary key
#  visit_id   :integer                                # 家访ID
#  child_id   :integer                                # 孩子ID
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VisitChild < ApplicationRecord
  belongs_to :child
  belongs_to :visit

  validates :visit_id, presence: true, numericality: {only_integer: true}
  validates :child_id, presence: true, numericality: {only_integer: true}
end
