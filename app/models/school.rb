# == Schema Information
#
# Table name: schools # 学校表
#
#  id                :integer          not null, primary key
#  name              :string                                 # 学校名称
#  address           :string                                 # 地址
#  approve_state     :integer          default("submit")     # 审核状态：1:待审核 2:通过 3:不通过
#  approve_remark    :string                                 # 审核备注
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  number            :integer                                # 学校人数
#  describe          :text                                   # 学校简介
#  state             :integer          default("enable")     # 学校状态：1:启用 2:禁用
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  level             :integer                                # 学校等级： 1:初中 2:高中
#  contact_name      :string                                 # 联系人
#  contact_phone     :string                                 # 联系方式
#  contact_position  :string                                 # 联系人职务
#  kind              :integer                                # 学校类型
#  user_id           :integer                                # 用户id
#  school_no         :string                                 # 学校申请编号
#  contact_idcard    :string                                 # 联系人身份证号
#  postcode          :string                                 # 邮政编码
#  teacher_count     :integer                                # 教师人数
#  logistic_count    :integer                                # 后勤人数
#  contact_telephone :string                                 # 联系人座机号码
#

class School < ApplicationRecord

  require 'custom_validators'

  attr_accessor :logo_id

  include HasAsset
  has_one_asset :logo, class_name: 'Asset::SchoolLogo'
  has_many_assets :images, class_name: 'Asset::SchoolImage'

  has_many :teachers, dependent: :destroy
  has_many :book_shelves
  has_many :project_season_applies
  has_many :gsh_children
  has_many :audits, as: :owner
  belongs_to :user, optional: true

  validates :name, :province, :city, :district, presence: true
  validates :contact_phone, mobile: true
  validates :contact_idcard, shenfenzheng_no: true

  enum state: {enable: 1, disable: 2} # 状态：1:启用 2:禁用
  default_value_for :state, 1

  enum level: {junior: 1, senior: 2} # 学校等级：1:初中 2:高中
  default_value_for :level, 1

  enum kind: {village_center_school: 1, small_village_village: 2, cheng_guan_primary_school: 3, other: 4} # 学校类型：1:乡村中心校 2:乡村村小 3:城关小学 4:其他

  enum approve_state: {submit: 1, pass: 2, rejected: 3} # 审核状态：1:待审核 2:审核通过 3：审核不通过
  default_value_for :approve_state, 1

  scope :sorted, ->{ order(created_at: :desc) }

  scope :can_check, ->{ where.not(approve_state: 2) }

  before_create :gen_school_no

  def full_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s + self.address.to_s
  end

  def simple_address
    ChinaCity.get(self.province).to_s + " " + ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  def short_address
    ChinaCity.get(self.city).to_s + " " + ChinaCity.get(self.district).to_s
  end

  private
  def gen_school_no
    time_string = Time.now.strftime("%y")
    self.school_no ||= Sequence.get_seq(kind: :school_no, prefix: time_string, length: 5)
  end

end
