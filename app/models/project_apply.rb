# == Schema Information
#
# Table name: project_applies # 项目申请表
#
#  id            :integer          not null, primary key
#  user_id       :integer                                # 用户ID
#  project_id    :integer                                # 项目ID
#  state         :integer          default(1)            # 状态：1:启用 2:禁用
#  approve_state :integer          default(1)            # 申请状态：1:审核中 2:审核通过 3:审核不通过
#  school_id     :integer                                # 学校ID
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ProjectApply < ApplicationRecord
end
