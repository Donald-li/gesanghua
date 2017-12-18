# == Schema Information
#
# Table name: child_grants # 孩子发放记录表
#
#  id               :integer          not null, primary key
#  child_id         :integer                                # 孩子ID
#  project_apply_id :integer                                # 项目申请ID
#  state            :integer                                # 状态
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ChildGrant < ApplicationRecord
  belongs_to :child
  belongs_to :project_apply

end
