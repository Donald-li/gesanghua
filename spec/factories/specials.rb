# == Schema Information
#
# Table name: specials # 专题表
#
#  id           :integer          not null, primary key
#  name         :string                                 # 专题名
#  template     :integer                                # 模板
#  describe     :string                                 # 简介
#  article_name :string                                 # 资讯名称
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :special do
    
  end
end
