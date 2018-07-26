# == Schema Information
#
# Table name: article_categories # 文章类别表
#
#  id         :bigint(8)        not null, primary key
#  name       :string                                 # 名称
#  position   :integer                                # 位置
#  state      :integer                                # 状态
#  describe   :string                                 # 描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ArticleCategory, type: :model do
end
