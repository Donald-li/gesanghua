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

# 举报
class Complaint < ApplicationRecord
  belongs_to :owner, polymorphic: true # project_season_apply;project_season_apply_child

  enum state: {submit: 1, check: 2} # 处理状态： 1:待处理 2:已处理
  default_value_for :state, 1

  validates :contact_name, :contact_phone, :content, presence: true
  validates :contact_phone, phone: true

  scope :sorted, ->{ order(created_at: :desc) }

  include HasAsset
  has_many_assets :images, class_name: 'Asset::ComplaintImage'


  def owner_name
    if self.owner.class.name == 'ProjectSeasonApply'
      self.owner.try(:apply_name)
    elsif self.owner.class.name == 'ProjectSeasonApplyChild'
      self.owner.try(:apply).try(:apply_name) + '-' + self.owner.try(:name)
    end
  end

  def owner_no
    if self.owner.class.name == 'ProjectSeasonApply'
      self.owner.try(:apply_no)
    elsif self.owner.class.name == 'ProjectSeasonApplyChild'
      self.owner.try(:gsh_child).try(:gsh_no)
    end
  end

end
