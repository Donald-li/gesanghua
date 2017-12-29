# == Schema Information
#
# Table name: reports # 报告表
#
#  id         :integer          not null, primary key
#  title      :string                                 # 标题
#  content    :text                                   # 内容
#  owner_type :string
#  owner_id   :integer
#  type       :string                                 # 单表：audit_report、financial_report、project_report
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectReport < Report
  belongs_to :owner, polymorphic: true

end
