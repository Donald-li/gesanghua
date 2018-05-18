# == Schema Information
#
# Table name: exception_records
#
#  id         :integer          not null, primary key
#  title      :string                                 # 标题
#  content    :string                                 # 内容
#  schedule   :string                                 # 进度更新
#  owner_type :string
#  owner_id   :integer
#  user_id    :integer                                # 提交人id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExceptionRecord < ApplicationRecord

  belongs_to :owner, polymorphic: true
  belongs_to :user, optional: true

  validates :title, presence: true
  validates :content, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  def get_district
    self.owner.try(:school).try(:district)
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :content)
      json.schedule self.schedule if self.schedule.present?
      json.school_name self.owner.try(:school).try(:name)
      json.school_contact_name self.owner.try(:school).try(:contact_name)
      json.school_contact_phone self.owner.try(:school).try(:contact_phone)
      json.created_at self.created_at.strftime("%Y-%m%-d")
    end.attributes!
  end
end
