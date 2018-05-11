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
#  title                   :string                                 # 消息标题
#

class Notification < ApplicationRecord
  before_create :set_assoc_attrs

  default_value_for :read, false

  belongs_to :owner, polymorphic: true
  belongs_to :user
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true


  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :content)
      json.school_name self.notification_school.try(:name)
      json.created_at self.created_at.strftime("%Y-%m-%d")
      json.school_contact_name self.notification_school.try(:contact_name)
      json.school_contact_phone self.notification_school.try(:contact_phone)
    end.attributes!
  end

  def notification_school
    return unless self.owner.class.name.in?(['ProjectSeasonApply', 'ProjectSeasonApplyBookshelf', 'BookshelfSupplement'])
    if self.owner.class.name.in?(['ProjectSeasonApply', 'ProjectSeasonApplyBookshelf'])
      school = self.owner.school
    elsif self.owner.class.name == 'BookshelfSupplement'
      school = self.owner.apply.school
    end
    school
  end

  def kind_title
  end

  def send_template_msg
    return unless self.user.profile['openid']
    template_id = title = keyword1 = url = nil
    case self.kind
    when /feedback_/
      title = '项目反馈'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = "#{Settings.m_root_url}/account/my-donate"
    when 'donate'
      title = '捐助结果'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = "#{Settings.m_root_url}/donate-records"
    when /project_/
      title = '项目进度'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = "#{Settings.m_root_url}/account/my-donate"
    when /approve_/
      title = '审核通知'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = "#{Settings.m_root_url}/cooperation"
    when 'exception_record'
      title = '异常提醒'
      template_id = Settings.wechat_template_notify
      keyword1 = self.content
      url = "#{Settings.m_root_url}/cooperation"
    else
      title = '消息提醒'
      template_id = Settings.wechat_template_notify
      keyword1 = self.content
      url = "#{Settings.m_root_url}/account"
    end
    user = self.user
    data = {
        first: {
            value: title,
            color: "#173277"
        },
        keyword1: {
            value: keyword1,
            color: "#173177"
        },
        keyword2: {
            value: self.created_at.to_s(:db),
            color: "#274177"
        },
        remark: {
            value: self.content,
            color: "#274377"
        }
    }
    $client.send_template_msg(self.user.profile['openid'], template_id, url, "#173177", data)
  end


  private
  def set_assoc_attrs
    owner = self.owner
    self.project = owner.project if owner.try(:project).present?
    self.season = owner.season if owner.try(:season).present?
    self.apply = owner.apply if owner.try(:apply).present?
  end
end
