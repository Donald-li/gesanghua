# == Schema Information
#
# Table name: feedbacks # 反馈表
#
#  id                                :bigint(8)        not null, primary key
#  content                           :text                                   # 内容
#  owner_type                        :string
#  owner_id                          :integer
#  type                              :string                                 # 类型：receive、install、continual
#  state                             :integer                                # 状态
#  approve_state                     :integer                                # 审核状态
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  kind                              :integer                                # 反馈类型
#  check                             :integer                                # 查看 1: 未查看 2: 已查看
#  recommend                         :integer                                # 推荐 1: 正常 2: 推荐
#  user_id                           :integer                                # 反馈人
#  project_id                        :integer                                # 项目id
#  project_season_id                 :integer                                # 批次id
#  project_season_apply_id           :integer                                # 申请id
#  project_season_apply_child_id     :integer                                # 孩子id
#  project_season_apply_bookshelf_id :integer                                # 书架id
#  class_name                        :string                                 # 反馈班级
#  gsh_child_grant_id                :integer                                # 学生某学期的持续反馈（感谢信）
#  school_id                         :integer                                # 学校id
#  arise_at                          :datetime                               # 开展时间
#  arise_class                       :string                                 # 开展班级
#  number                            :integer                                # 参与人数
#

# 反馈表
class Feedback < ApplicationRecord
  include SanitizeContent
  sanitize_content :content

  belongs_to :owner, polymorphic: true
  belongs_to :user
  belongs_to :project
  belongs_to :school, optional: true
  belongs_to :gsh_child_grant, optional: true # TODO 与下边关系重复
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :child, class_name: "ProjectSeasonApplyChild", foreign_key: 'project_season_apply_child_id', optional: true
  belongs_to :bookshelf, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_bookshelf_id', optional: true
  belongs_to :grant, class_name: 'GshChildGrant', foreign_key: 'gsh_child_grant_id', optional: true

  validates :content, presence: true

  include HasAsset
  has_many_assets :images, class_name: "Asset::FeedbackImage"

  enum kind: {default: 0, grant: 1, continue: 2, score: 3}
  default_value_for :kind, 0

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  enum check: {uncheck: 1, checked: 2}# 查看 1: 未查看 2: 已查看
  default_value_for :check, 1

  enum recommend: {normal: 1, recommend: 2}# 推荐 1: 正常 2: 推荐
  default_value_for :recommend, 1

  enum approve_state: {submit: 1, pass: 2, reject: 3} # 审核状态 1:审核中 2:申请通过 3:申请不通过
  default_value_for :approve_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  counter_culture :gsh_child_grant, column_name: "feedback_count"

  # TODO 直接使用user的头像即可
  def avatar_url
    if self.child.try(:avatar).present?
      self.child.avatar_url(:tiny)
    elsif self.user.try(:avatar).present?
      self.user.avatar_url(:tiny)
    else
      ''
    end
  end

  def formatted_content
    self.content.gsub(/\n/, '<br>')
  end

  def user_show_name
    self.grant.present? ? "尊敬的：#{self.grant.try(:donator).try(:name)}" : self.user.show_name
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :arise_class, :number)
      json.time self.created_at
      json.arise_at self.arise_at.present? ? self.arise_at.strftime('%Y-%m-%d %H:%M') : ''
      json.name self.owner.name
      json.content self.formatted_content
      json.user_name self.user_show_name
      # json.avatar self.child.avatar.present? ? self.child.avatar_url(:tiny).to_s : ''
      json.avatar self.avatar_url
      json.images do
        json.array! self.images do |img|
          json.id img.id
          json.thumb img.file_url(:tiny)
          json.src img.file_url
          json.w img.width
          json.h img.height
        end
      end
    end.attributes!
  end

  def self.generate_qrcode
    qrcode = RQRCode::QRCode.new(self.share_url)
    png = qrcode.as_png(
        resize_gte_to: true,
        resize_exactly_to: true,
        fill: 'white',
        color: 'black',
        size: 480,
        border_modules: 0,
        module_px_size: 1,
        file: nil # path to write
    )
    FileUtils.mkdir_p("public/uploads/qrcode") unless File.exists?("public/uploads/qrcode")
    f = File.new("public/uploads/qrcode/pair_feedback.png", "w+")
    f.syswrite(png)
  end

  def self.qrcode_url
    self.generate_qrcode unless File.exists?("public/uploads/qrcode/pair_feedback.png")
    "/uploads/qrcode/pair_feedback.png"
  end

  def self.share_url
    "#{Settings.pair_feedback_url}"
  end

end
