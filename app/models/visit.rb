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
#

class Visit < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: true

  has_many :visit_children

  belongs_to :apply_child, class_name: 'ProjectSeasonApplyChild', optional: true

  validates :content, presence: true

  scope :sorted, ->{ order(created_at: :desc) }
end
