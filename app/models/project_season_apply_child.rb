# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  gsh_child_id            :integer                                # 关联格桑花孩子表id
#  name                    :string                                 # 孩子姓名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  phone                   :string                                 # 电话
#  qq                      :string                                 # QQ号码
#  nation                  :integer                                # 民族
#  id_card                 :string                                 # 身份证号码
#  parent_name             :string                                 # 家长姓名
#  description             :text                                   # 描述
#  state                   :integer                                # 状态
#  approve_state           :integer                                # 审核状态
#  age                     :integer                                # 年龄
#  level                   :integer                                # 初中或高中
#  grade                   :integer                                # 年级
#  gender                  :integer                                # 性别
#  school_id               :integer                                # 学校ID
#  semester                :integer                                # 学期
#  kind                    :integer                                # 捐助形式：1对外捐助 2内部认捐
#

class ProjectSeasonApplyChild < ApplicationRecord

  require 'custom_validators'

  # attr_accessor :image_ids
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ApplyChildImage'

  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id'
  belongs_to :gsh_child, optional: true
  belongs_to :school
  has_one :visit, foreign_key: 'apply_child_id'
  has_many :audits, as: :owner
  has_many :remarks, as: :owner
  has_many :complaints, as: :owner

  has_many :period_child_ships
  has_many :project_season_apply_periods, through: :period_child_ships
  accepts_nested_attributes_for :project_season_apply_periods
  accepts_nested_attributes_for :audits

  # validates :id_card, ShenfenzhengNo: true
  validates :id_card, :name, :phone, presence: true
  validates :province, :city, :district, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏
  default_value_for :state, 2

  enum approve_state: {submit: 1, pass: 2, rejected: 3} # 状态：1:待审核 2:通过 3:不通过
  default_value_for :approve_state, 1

  enum gender: {male: 1, female: 2,} # 状态：1:男 2:女
  default_value_for :gender, 1

  enum level: {junior: 1, senior: 2} # 状态：1:初中 2:高中
  default_value_for :level, 1

  enum kind: {outside: 1, inside: 2} # 捐助形式：1:对外捐助 2:内部认捐
  default_value_for :kind, 1

  enum grade: {one: 1, two: 2, three: 3} # 年级：1:一年级 2:二年级, 3:三年级
  default_value_for :grade, 1

  enum semester: {last_term: 1, next_term: 2} # 学期： 1:上学期 2:下学期
  default_value_for :semester, 1

  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56 }
  default_value_for :nation, 0


  scope :sorted, ->{ order(created_at: :desc) }

  def count_age
    birthday = ChinesePid.new("#{self.id_card}").birthday
    today = Date.today
    child_age = (today - birthday).to_i/365
    self.update_columns(age: child_age)
  end

  def raise_process
    return "#{self.gsh_child.gsh_child_grants.succeed.count} / #{self.gsh_child.gsh_child_grants.count}"
  end

  def raise_condition
    total = self.gsh_child.gsh_child_grants.count
    num = total - self.gsh_child.gsh_child_grants.succeed.count

    if num == 0
      '筹款完成'
    elsif num == total
      '筹款中'
    else
      '可续捐'
    end
  end

  def generate_qrcode
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
    f = File.new("public/uploads/qrcode/#{self.id}.png", "w+")
    f.syswrite(png)
  end

  def qrcode_url
    "/uploads/qrcode/#{self.id}.png"
  end

  def share_url
    # Rails.application.routes.url_helpers.q_url(:host => Settings.app_host, child_id: self.id)
    'https://www.baidu.com' # TODO 前段路由定义以后修改为正确的路由
  end

  # 通过审核
  def approve_pass
    self.approve_state = 'pass'
    if self.gsh_child_id.nil?
      self.gsh_child = self.create_gsh_child
      self.apply.gsh_child = self.gsh_child
    end
    self.save
    self.gen_grant_record
  end

  # 审核不通过
  def approve_reject
    self.approve_state = 'rejected'
    self.save
  end

  def child_grade_integer
    ProjectSeasonApplyChild.send(:grades)[self.grade]
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.secrecy_name
      json.gsh_no self.gsh_child.try(:gsh_no)
      json.remarks_string self.remarks_string
    end.attributes!
  end

  def self.address_group
    Jbuilder.new do |json|
      json.city self.city_group
    end.attributes!
  end

  def secrecy_name
    name = self.name
    name[1..(name.size - 2)] = '*' * (name.size - 2)
    return name
  end

  def remarks_string
    self.remarks.map{|remark| remark.content}.join('、').slice(0..8)
  end

  def self.city_group
    self.all.group_by{|child| child.city}.keys.map{|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
  end

  def self.district_group(city)
    self.where(city: city).group_by{|child| child.district}.keys.map{|key| {value: key, name: ChinaCity.get(key)}}
  end

  def get_tuition
    if self.junior?
      return self.season.junior_year_amount
    else
      return self.season.senior_year_amount
    end
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.age self.age
      json.level self.enum_name(:level)
      json.gsh_no self.gsh_child.gsh_no
      json.tuition self.get_tuition.to_i
      json.description self.description
      json.grants do
        json.array! self.gsh_child.gsh_child_grants.reverse_sorted do |grant|
          json.(grant, :id)
          json.(grant, :title)
          json.(grant, :amount)
          json.donate_state grant.donate_state
        end
      end
      json.images do
        json.array! self.images do |image|
          json.(image, :id)
          json.image image.file.url
        end
      end
    end.attributes!
  end

  protected

  def create_gsh_child
    gsh_child = GshChild.new
    gsh_child.school_id = self.apply.school_id
    gsh_child.province = self.province
    gsh_child.city = self.city
    gsh_child.district = self.district
    gsh_child.name = self.name
    gsh_child.phone = self.phone
    gsh_child.qq = self.qq
    gsh_child.save
    return gsh_child
  end

  def gen_grant_record
    GshChildGrant.gen_grant_record(self.gsh_child)
  end

end
