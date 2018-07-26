# == Schema Information
#
# Table name: operate_logs
#
#  id         :bigint(8)        not null, primary key
#  user_id    :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OperateLog < ApplicationRecord

  belongs_to :user, optional: true

  scope :sorted, ->{ order(created_at: :desc) }

  def self.create_export_excel(user, title)
    self.create(user: user, title: "导出#{title}")
  end

end
