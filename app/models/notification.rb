# == Schema Information
#
# Table name: notifications
#
#  id                      :integer          not null, primary key
#  push_type               :integer                                # bit_enum，邮件、短信、微信
#  kind                    :string                                 # 类型，通知类型
#  from_user_id            :integer                                # 发起用户
#  user_id                 :integer                                # 通知用户
#  project_id              :integer                                # 项目
#  project_season_id       :integer                                # 批次
#  project_season_apply_id :integer                                # 申请
#  owner_type              :string
#  owner_id                :integer
#  content                 :text                                   # 内容
#  read                    :boolean                                # 是否已读
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Notification < ApplicationRecord

  # 审核完成
  def self.audit_done(owner, user_id, content='')
    notice = self.new
    notice.user_id = user_id

    notice.project_id = owner.project_id if owner.project.present?
    notice.project_season_id = owner.project_season_id if owner.season.present?
    notice.project_season_apply_id = owner.project_season_apply_id if owner.apply.present?
  end

  # 筹款成功
  def self.raise_success
  end

  # 发放完成
  def self.grant_done
  end

  # 安装反馈
  def self.install_feedback
  end

  # 收货反馈
  def self.receipt_feedback
  end

  private
  # 反馈通知
  def feedback
  end
end
