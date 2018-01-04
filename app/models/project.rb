# == Schema Information
#
# Table name: new_projects
#
#  id         :integer          not null, primary key
#  type       :string                                 # 单表继承字段
#  kind       :integer                                # 项目类型 1:固定项目 2:物资类项目
#  name       :string                                 # 项目名称
#  protocol   :text                                   # 用户协议
#  fund       :integer                                # 关联财务分类id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ApplicationRecord
  belongs_to :fund, optional: true

  validates :name, :protocol, presence: true

  enum kind: { normal: 1, goods: 2 }

end
