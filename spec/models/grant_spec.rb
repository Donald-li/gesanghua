# == Schema Information
#
# Table name: grants # 发放表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 归属项目ID
#  project_season_id       :integer                                # 项目年度ID
#  school_id               :integer                                # 学校ID
#  project_season_apply_id :integer                                # 项目申请ID
#  gsh_child_id            :integer                                # 格桑花孩子ID
#  grant_no                :string                                 # 发放编号
#  state                   :integer                                # 状态
#  amount                  :decimal(14, 2)   default(0.0)          # 资助金额
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  grant_batch_id          :integer                                # 批次号
#

require 'rails_helper'

RSpec.describe Grant, type: :model do
  
end
