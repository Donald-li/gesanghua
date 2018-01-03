# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id         :integer          not null, primary key
#  project_id :integer                                # 关联项目表id
#  name       :string                                 # 执行年度名称
#  state      :integer                                # 状态 1:未执行 2:执行中
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectSeason, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
