# == Schema Information
#
# Table name: visits # 家访记录表
#
#  id             :integer          not null, primary key
#  owner_id       :integer
#  owner_type     :string
#  content        :text                                   # 内容
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  apply_child_id :integer                                # 孩子申请ID
#  user_id        :integer                                # 用户ID
#

# 家访
class Visit < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true

  has_many :visit_children

  belongs_to :apply_child, class_name: 'ProjectSeasonApplyChild', optional: true
  belongs_to :user

  validates :content, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  def simple_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.author self.user.name
      json.child self.apply_child.name
    end.attributes!
  end
end
