# == Schema Information
#
# Table name: camp_document_resources # 拓展营资源表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 项目
#  user_id           :integer                                # 用户
#  company           :string                                 # 单位名称
#  resource          :string                                 # 资源名称
#  contact_name      :string                                 # 联系人
#  contact_phone     :string                                 # 联系人电话
#  gsh_contact_name  :string                                 # 格桑花联系人
#  gsh_contact_phone :string                                 # 格桑花联系人电话
#  remark            :string                                 # 资源说明
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe CampProjectResource, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
