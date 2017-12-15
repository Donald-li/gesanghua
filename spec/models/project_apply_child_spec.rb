# == Schema Information
#
# Table name: project_apply_children # 一对一孩子申请表
#
#  id               :integer          not null, primary key
#  project_apply_id :integer                                # 项目申请ID
#  child_id         :integer                                # 格桑花孩子ID
#  approve_state    :integer                                # 审核状态：1:审核中 2:申请通过 3:申请不通过
#  province         :string                                 # 省
#  city             :string                                 # 市
#  district         :string                                 # 区/县
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectApplyChild, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
