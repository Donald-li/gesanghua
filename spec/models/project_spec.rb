# == Schema Information
#
# Table name: projects # 项目表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 项目名称
#  type                :string                                 # 项目类型：1:结对 2:物资 3:悦读 4:营 5:观影
#  content             :text                                   # 项目内容
#  state               :integer          default("enabled")    # 项目状态：1:启用 2:禁用
#  finance_category_id :integer                                # 财务分类ID
#  contribute_kind     :integer          default("entirety")   # 捐款类型：1:整捐 2:零捐
#  category_type       :string                                 # 具体项目分类
#  category_id         :integer                                # 分类ID
#  project_template_id :integer                                # 项目模板ID
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
