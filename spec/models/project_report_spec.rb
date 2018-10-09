# == Schema Information
#
# Table name: project_reports # 项目报告表
#
#  id           :bigint(8)        not null, primary key
#  title        :string                                 # 标题
#  content      :text                                   # 内容
#  state        :integer                                # 状态：1显示 2隐藏
#  project_id   :integer                                # 项目id
#  published_at :datetime                               # 发布时间
#  kind         :integer                                # 类型: 1项目报告 2回访报告
#  position     :integer                                # 位置
#  user_id      :integer                                # 发布人
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  comment      :text
#

require 'rails_helper'

RSpec.describe ProjectReport, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
