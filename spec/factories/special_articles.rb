# == Schema Information
#
# Table name: special_articles # 专题资讯表
#
#  id         :integer          not null, primary key
#  special_id :integer                                # 专题id
#  article_id :integer                                # 资讯id
#  position   :integer                                # 排序
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :special_article do
    
  end
end