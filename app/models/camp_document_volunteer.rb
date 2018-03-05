# == Schema Information
#
# Table name: camp_document_volunteers # 拓展营志愿者表
#
#  id           :integer          not null, primary key
#  project_id   :integer                                # 项目
#  user_id      :integer                                # 用户
#  volunteer_id :integer                                # 志愿者
#  remark       :string                                 # 营备注
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class CampDocumentVolunteer < ApplicationRecord
end
