# == Schema Information
#
# Table name: project_templates # 项目模板表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 项目模板名称
#  kind                :integer                                # 模板类型
#  finance_category_id :integer                                # 财务分类ID
#  protocol_name       :string                                 # 协议名称
#  protocol_content    :text                                   # 协议内容
#  contribute_kind     :integer          default("entirety")   # 捐款类型：1:整捐 2:零捐
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProjectTemplate < ApplicationRecord
  belongs_to :finance_category

  has_many :projects

  validates :name, :protocol_name, :protocol_content, presence: true

  enum contribute_kind: { entirety: 1, scattered: 2 } # 捐款类型：1:整捐 2:零捐
  default_value_for :contribute_kind, 1

  scope :sorted, ->{ order(created_at: :desc) }
end
