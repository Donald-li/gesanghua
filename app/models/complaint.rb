# == Schema Information
#
# Table name: complaints # 举报表
#
#  id            :integer          not null, primary key
#  contact_name  :string                                 # 联系人姓名
#  contact_phone :string                                 # 联系人手机
#  content       :text                                   # 举报详情
#  owner_type    :string
#  owner_id      :integer
#  state         :integer                                # 处理状态： 1:submit 2:check
#  remark        :text                                   # 处理备注
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Complaint < ApplicationRecord
  belongs_to :owner, polymorphic: true

  enum state: {submit: 1, check: 2} # 处理状态： 1:待处理 2:已处理
  default_value_for :state, 1

  validates :contact_name, :contact_phone, :content, presence: true
  validates :contact_phone, phone: true

  scope :sorted, ->{ order(created_at: :desc) }

  def sliced_content
    self.content.slice(0..90)
  end
end
