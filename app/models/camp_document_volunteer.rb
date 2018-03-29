# == Schema Information
#
# Table name: camp_document_volunteers # 拓展营志愿者表
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  volunteer_id            :integer                                # 志愿者
#  remark                  :string                                 # 营备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#

class CampDocumentVolunteer < ApplicationRecord
  belongs_to :apply, class_name: 'ProjectSeasonApply'
  belongs_to :user
  belongs_to :camp
  belongs_to :volunteer

  scope :sorted, ->{order(id: :asc)}
  scope :in_season, ->(project_season){where(project_season: project_season)}
end
