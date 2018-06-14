# == Schema Information
#
# Table name: camp_document_volunteers # 拓展营志愿者表
#
#  id                      :integer          not null, primary key
#  user_id                 :integer                                # 用户
#  volunteer_id            :integer                                # 志愿者
#  remark                  :string                                 # 营备注
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  project_season_apply_id :integer                                # 探索营申请id
#  camp_id                 :integer                                # 探索营id
#  volunteer_no            :string                                 # 志愿者编号
#  name                    :string                                 # 姓名
#  gender                  :integer                                # 性别
#  id_card                 :string                                 # 身份证号
#  phone                   :string                                 # 手机号
#  content                 :text                                   # 工作内容
#

require 'custom_validators'
class CampDocumentVolunteer < ApplicationRecord
  has_paper_trail only: [:volunteer_id, :remark, :project_season_apply_id, :camp_id]

  after_save :distinguish_gender

  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id
  belongs_to :user
  belongs_to :camp
  # belongs_to :volunteer

  include HasAsset
  has_one_asset :camp_volunteer_excel, class_name: 'Asset::CampVolunteerExcel'

  validates :name, :phone, :id_card, presence: true
  validates :id_card, shenfenzheng_no: true
  validates :id_card, uniqueness: true

  enum gender: {unknow: 0, male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 0

  scope :sorted, ->{order(id: :desc)}
  scope :in_apply, ->(apply){where(apply: apply)}

  # 操作日志查找关系
  def project_season_apply
      self.apply
  end

  def self.excel_template
    '/excel/templates/探索营志愿者导入模板.xlsx'
  end

  def self.read_excel(excel_id, apply, user)
    file = Asset.find(excel_id).try(:file).try(:file)
    FileUtil.import_camp_volunteers(original_filename: file.original_filename, path: file.path, apply: apply, user: user) if file.present?
  end

  def distinguish_gender
    return if self.gender.present?
    pid_gender = ChinesePid.new("#{self.id_card}").gender
    gender = :male if pid_gender == 1
    gender = :female if pid_gender == 0
    self.update_columns(gender: gender)
  end

end
