# == Schema Information
#
# Table name: notifications
#
#  id                      :bigint(8)        not null, primary key
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
#  url                     :string
#

class Notification < ApplicationRecord
  before_create :set_assoc_attrs

  default_value_for :read, false

  belongs_to :owner, polymorphic: true
  belongs_to :user
  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true

  after_create :send_template_msg

  scope :sorted, -> {order(created_at: :desc)}
  scope :to_check, -> {where(read: false)}

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

  def redirect_url
    case self.kind
      when /feedback_/
        self.url || "#{Settings.root_url}account/orders"
      when 'donate'
        self.url || "#{Settings.root_url}account/orders"
      when /project_/
        self.url || "#{Settings.root_url}account/orders"
      when /approve_/
        self.url || "#{Settings.root_url}gsh_plus"
      when 'exception_record'
        self.url || "#{Settings.root_url}platform"
      when 'child_granted'
        self.url || "#{Settings.root_url}account/pairs"
      when 'appoint_donor'
        self.url || "#{Settings.root_url}account/pairs"
      when 'continue_donate'
        self.url || "#{Settings.root_url}pairs/#{self.owner_id}/detail"
      else
        self.url || "#{Settings.root_url}platform"
    end
  end

  def send_template_msg
    return unless self.user.profile['openid']
    template_id = title = keyword1 = url = nil
    case self.kind
    when /feedback_/
      title = '项目反馈'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = self.url || "#{Settings.m_root_url}/account/my-donate"
    when 'donate'
      title = '捐助结果'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = self.url || "#{Settings.m_root_url}/donate-records"
    when /project_/
      title = '项目进度'
      template_id = Settings.wechat_template_project
      keyword1 = self.project.try(:name)
      url = self.url || "#{Settings.m_root_url}/account/my-donate"
    when /approve_/
      title = '审核通知'
      template_id = Settings.wechat_template_approve
      keyword1 = self.project.try(:name)
      url = self.url || "#{Settings.m_root_url}/gesanghua+"
    when 'exception_record'
      title = '异常提醒'
      template_id = Settings.wechat_template_notify
      keyword1 = self.content
      url = self.url || "#{Settings.m_root_url}/cooperation"
    when 'child_granted'
      title = self.title
      template_id = Settings.wechat_template_project
      keyword1 = self.content
      url = self.url || "#{Settings.m_root_url}/account/my-pairs"
    when 'appoint_donor'
      title = self.title
      template_id = Settings.wechat_template_notify
      keyword1 = self.content
      url = self.url || "#{Settings.m_root_url}/account/my-pairs"
    when 'continue_donate'
      title = self.title
      template_id = Settings.wechat_template_project
      keyword1 = self.content
      url = self.url || "#{Settings.m_root_url}/pair/#{self.owner_id}"
    else
      title = '消息提醒'
      template_id = Settings.wechat_template_notify
      keyword1 = self.content
      url = self.url || "#{Settings.m_root_url}/account"
    end

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
            value: self.created_at.localtime.to_s(:db),
            color: "#274177"
        },
        remark: {
            value: self.content,
            color: "#274377"
        }
    }
    result = $client.send_template_msg(self.user.openid, template_id, url, "#173177", data) # if self.user.openid.present?
    logger.info '==========微信消息发送==========='
    logger.info result.inspect
  end


  private
  def set_assoc_attrs
    owner = self.owner
    self.project = owner.project if owner.try(:project).present?
    self.season = owner.season if owner.try(:season).present?
    self.apply = owner.apply if owner.try(:apply).present?
  end
end
