# == Schema Information
#
# Table name: specials # 专题表
#
#  id           :bigint(8)        not null, primary key
#  name         :string                                 # 专题名
#  template     :integer                                # 模板
#  describe     :text                                   # 简介
#  article_name :string                                 # 资讯名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  state        :integer          default("show")       # 状态, 1:展示 2:隐藏
#  author       :string                                 # 编辑人
#  article_id   :integer                                # 资讯id
#  published_at :datetime                               # 发布时间
#

require 'rails_helper'

RSpec.describe Special, type: :model do
  
end
