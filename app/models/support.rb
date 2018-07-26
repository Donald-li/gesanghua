# == Schema Information
#
# Table name: supports # 帮助中心主题
#
#  id                  :bigint(8)        not null, primary key
#  title               :string                                 # 标题
#  content             :text                                   # 内容
#  position            :integer                                # 排序
#  state               :integer                                # 状态
#  support_category_id :integer                                # 帮助中心分类id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  display_position    :integer                                # 显示位置
#

# 帮助中心
class Support < ApplicationRecord
  # belongs_to :support_category

  validates :title, presence: true

  acts_as_list column: :position
  scope :sorted, ->{ order(position: :asc) }

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  enum display_position: {pc_support: 1, wechat_support: 2} #显示位置： 1:pc端 2:微信端

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title)
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :content)
    end.attributes!
  end
end
