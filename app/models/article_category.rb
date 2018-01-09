# == Schema Information
#
# Table name: article_categories # 文章类别表
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  position   :integer                                # 位置
#  state      :integer                                # 状态
#  describe   :string                                 # 描述
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArticleCategory < ApplicationRecord
  has_many :articles

  validates :name, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

end
