# == Schema Information
#
# Table name: project_reports # 项目报告表
#
#  id           :bigint(8)        not null, primary key
#  title        :string                                 # 标题
#  content      :text                                   # 内容
#  state        :integer                                # 状态：1显示 2隐藏
#  project_id   :integer                                # 项目id
#  published_at :datetime                               # 发布时间
#  kind         :integer                                # 类型: 1项目报告 2回访报告
#  position     :integer                                # 位置
#  user_id      :integer                                # 发布人
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  comment      :text
#

# 项目报告
class ProjectReport < ApplicationRecord
  include SanitizeContent
  sanitize_content :content

  validates :title, :content, :published_at, presence: true

  belongs_to :project, optional: true
  belongs_to :user, optional: true

  scope :sorted, ->{ order(published_at: :desc) }

  enum state: {show: 1, hidden: 2} # 状态 1:显示 2:隐藏
  default_value_for :state, 1

  enum kind: {project_report: 1, visit_report: 2, grant_report: 3} # 类型 1:项目报告 2:家访报告 3:发放报告
  default_value_for :kind, 1

  include HasAsset
  has_many_assets :report_files, class_name: 'Asset::ProjectReportFile'
  has_many_assets :images, class_name: 'Asset::ProjectReportImage'

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.title self.title
      json.published_at self.published_at.strftime('%Y-%m-%d')
      json.publisher self.try(:user).try(:show_name)
      json.content self.formatted_content
      json.report_images do
        json.array! self.images do |img|
          json.id img.id
          json.thumb img.file_url(:small)
          json.src img.file_url
          json.w img.width
          json.h img.height
        end
      end
    end.attributes!
  end

  def formatted_content
    self.content.present? ? self.content.gsub(/\r\n/, '<br>').gsub(/(<br\/*>\s*){1,}/, '<br>') : ''
  end

  def published_time
    self.published_at.strftime("%Y年%m月%d日")
  end

end
