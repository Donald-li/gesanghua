class ProjectReport < ApplicationRecord

  validates :title, :content, :published_at, presence: true

  belongs_to :project, optional: true
  belongs_to :user, optional: true

  scope :sorted, ->{ order(created_at: :desc) }

  enum state: {show: 1, hidden: 2} # 状态 1:显示 2:隐藏
  default_value_for :state, 1

  enum kind: {project_report: 1, visit_report: 2} # 类型 1:项目报告 2:回访报告
  default_value_for :kind, 1

  include HasAsset
  has_many_assets :report_files, class_name: 'Asset::ProjectReportFile'
  has_many_assets :images, class_name: 'Asset::ProjectReportImage'

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.title self.title
      json.published_at self.published_at.strftime('%Y-%m-%d')
      json.publisher self.try(:user).try(:name)
      json.content self.content
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

end
