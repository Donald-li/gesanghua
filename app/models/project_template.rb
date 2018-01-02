# == Schema Information
#
# Table name: project_templates # 项目模板表
#
#  id               :integer          not null, primary key
#  name             :string                                 # 项目模板名称
#  kind             :integer                                # 模板类型
#  fund_id          :integer                                # 基金ID
#  protocol_name    :string                                 # 协议名称
#  protocol_content :text                                   # 协议内容
#  contribute_kind  :integer          default("entirety")   # 捐款类型：1:整捐 2:零捐
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ancestry         :string
#  describe         :text                                   # 描述
#

class ProjectTemplate < ApplicationRecord

  has_ancestry

  belongs_to :fund

  has_many :projects
  has_many :pairs

  validates :name, :protocol_name, :protocol_content, presence: true

  enum contribute_kind: { entirety: 1, scattered: 2 } # 捐款类型：1:整捐 2:零捐
  default_value_for :contribute_kind, 1

  enum kind: { system: 1, custom: 2 } # 类型：1:系统默认 2:用户新增
  default_value_for :kind, 2

  scope :sorted, ->{ order(created_at: :asc) }

  def self.options_for_select
    self.all.map{|c| [c.name, c.id]}
  end

  def sliced_describe
    self.describe.length > 100 ? self.describe.slice(0..100) + '...' : self.describe
  end
end
