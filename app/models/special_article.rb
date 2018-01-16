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

class SpecialArticle < ApplicationRecord
  belongs_to :special
  belongs_to :article

  acts_as_list
  scope :reverse_sorted, ->{ order(position: :asc) }
end
