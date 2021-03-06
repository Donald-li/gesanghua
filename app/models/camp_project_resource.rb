# == Schema Information
#
# Table name: camp_project_resources # 拓展营资源表
#
#  id                :bigint(8)        not null, primary key
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
#  camp_id           :integer                                # 探索营id
#

require 'custom_validators'

class CampProjectResource < ApplicationRecord
  has_paper_trail only: [:company, :resource, :contact_name, :contact_phone, :gsh_contact_name, :gsh_contact_phone, :remark, :camp_id]

  belongs_to :user
  belongs_to :camp

  scope :sorted, ->{order(id: :asc)}

  validates :company, :resource, :contact_name, :gsh_contact_name, presence: true
  validates :contact_phone, :gsh_contact_phone, presence: true
  validates :contact_phone, :gsh_contact_phone, phone: true

end
