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
#  reason                  :string                                 # 结对申请理由
#  donate_user_id          :integer                                # 捐助人id
#  gsh_no                  :string                                 # 格桑花孩子编号
#  semester_count          :integer                                # 学期数
#  done_semester_count     :integer                                # 已完成的学期数
#  user_id                 :integer                                # 关联的用户ID
#  teacher_name            :string                                 # 班主任
#  father                  :string                                 # 父亲
#  father_job              :string                                 # 父亲职业
#  mother                  :string                                 # 母亲
#  mother_job              :string                                 # 母亲职业
#  guardian                :string                                 # 监护人
#  guardian_relation       :string                                 # 与监护人关系
#  guardian_phone          :string                                 # 监护人电话
#  address                 :string                                 # 家庭住址
#  family_income           :decimal(14, 2)   default(0.0)          # 家庭年收入
#  family_expenditure      :decimal(14, 2)   default(0.0)          # 家庭年支出
#  income_source           :string                                 # 收入来源
#  family_condition        :string                                 # 家庭情况
#  brothers                :string                                 # 兄弟姐妹
#  teacher_phone           :string                                 # 班主任联系方式
#

# 项目年度结对申请孩子
require 'custom_validators'
class ProjectSeasonApplyChild < ApplicationRecord

  before_update :update_pair_state, if: :can_update_pair_state?

  attr_accessor :avatar_id
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ApplyChildImage'
  has_one_asset :avatar, class_name: 'Asset::ApplyChildAvatar' # 前台上传的个人照片作为孩子头像
  has_one_asset :id_image, class_name: 'Asset::ApplyChildIdCard'
  has_one_asset :residence, class_name: 'Asset::ApplyChildResidence'
  has_one_asset :poverty, class_name: 'Asset::ApplyChildPoverty'
  has_one_asset :family_image, class_name: 'Asset::ApplyChildFamilyImage'

  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id'
  belongs_to :gsh_child, optional: true
  belongs_to :school
  belongs_to :user, optional: true
  has_many :visits, foreign_key: 'apply_child_id'
  has_many :audits, as: :owner
  has_many :remarks, as: :owner
  has_many :complaints, as: :owner
  has_many :donates, class_name: 'DonateRecord', dependent: :destroy
  has_many :gsh_child_grants, foreign_key: :gsh_child_id, dependent: :destroy
  #FIXME: 跟上面的关系重复了？
  has_many :semesters, foreign_key: :gsh_child_id, class_name: 'GshChildGrant', dependent: :destroy
  has_many :feedbacks, as: :owner
  has_many :continual_feedbacks

  has_many :period_child_ships
  has_many :project_season_apply_periods, through: :period_child_ships
  accepts_nested_attributes_for :project_season_apply_periods
  accepts_nested_attributes_for :audits

  attr_accessor :approve_remark

  # validates :id_card, ShenfenzhengNo: true
  validates :id_card, :name, presence: true
  validates :province, :city, :district, presence: true
  validates :reason, length: {maximum: 20}

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏
  default_value_for :state, 2

  enum approve_state: {draft: 0, submit: 1, pass: 2, reject: 3} # 状态：1:待审核 2:通过 3:不通过
  default_value_for :approve_state, 0

  enum gender: {male: 1, female: 2, } # 状态：1:男 2:女
  default_value_for :gender, 1

  enum level: {junior: 1, senior: 2} # 状态：1:初中 2:高中
  default_value_for :level, 1

  enum kind: {outside: 1, inside: 2} # 捐助形式：1:对外捐助 2:内部认捐
  default_value_for :kind, 1

  enum grade: {one: 1, two: 2, three: 3} # 年级：1:一年级 2:二年级, 3:三年级
  default_value_for :grade, 1

  enum semester: {last_term: 1, next_term: 2} # 学期： 1:上学期 2:下学期
  default_value_for :semester, 1

  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56}
  default_value_for :nation, 0

  scope :sorted, -> {order(created_at: :desc)}
  scope :check_list, -> {where(approve_state: [1, 2, 3])}

  def gsh_no
    self.gsh_child.try(:gsh_no)
  end

  def count_age
    birthday = ChinesePid.new("#{self.id_card}").birthday
    today = Date.today
    child_age = (today - birthday).to_i/365
    self.update_columns(age: child_age)
  end

  # 筹款进度
  def gift_progress
    "#{self.done_semester_count}/#{self.semester_count}"
  end

  def raise_process
    return "#{self.gsh_child_grants.succeed.count} / #{self.gsh_child_grants.count}"
  end

  def raise_condition
    total = self.gsh_child_grants.count
    num = total - self.gsh_child_grants.succeed.count

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
    f = File.new("public/uploads/qrcode/#{self.gsh_no}.png", "w+")
    f.syswrite(png)
  end

  def qrcode_url
    "/uploads/qrcode/#{self.gsh_no}.png"
  end

  def share_url
    # Rails.application.routes.url_helpers.q_url(:host => Settings.app_host, child_id: self.id)
    'https://www.baidu.com' # TODO 前段路由定义以后修改为正确的路由
  end

  # 通过审核
  def approve_pass
    self.approve_state = 'pass'
    if self.gsh_child_id.nil?
      self.gsh_child = GshChild.find_by(id_card: self.id_card) || self.create_gsh_child
      # self.apply.gsh_child = self.gsh_child
    end
    self.save
    self.gen_grant_record
  end

  # 审核不通过
  def approve_reject
    self.approve_state = 'reject'
    self.save
  end

  def child_grade_integer
    ProjectSeasonApplyChild.send(:grades)[self.grade]
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :age, :name)
      json.level self.enum_name(:level)
      json.gsh_no self.gsh_no
      json.remarks_string self.remarks_string
    end.attributes!
  end

  def self.address_group
    Jbuilder.new do |json|
      json.city self.city_group
    end.attributes!
  end

  def remarks_string
    self.remarks.map {|remark| remark.content}.join('、').slice(0..8)
  end

  def self.city_group
    self.show.group_by {|child| child.city}.keys.map {|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
  end

  def self.district_group(city)
    self.show.where(city: city).group_by {|child| child.district}.keys.map {|key| {value: key, name: ChinaCity.get(key)}}
  end

  def get_tuition
    if self.junior?
      return self.season.junior_year_amount
    else
      return self.season.senior_year_amount
    end
  end

  # 捐助一个受助学生
  def donate_child

  end

  # 受助学生的全部捐助记录
  def donate_all_records
    self.gsh_child_grants.reverse_sorted
  end

  # 受助学生未筹款的记录
  def donate_pending_records
    self.gsh_child_grants.pending.reverse_sorted
  end

  # 受助学生筹款成功的记录
  def donate_succeed_records
    self.gsh_child_grants.succeed.reverse_sorted
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.age self.age
      json.level self.enum_name(:level)
      json.gsh_no self.gsh_no
      json.tuition self.get_tuition.to_i
      json.description self.description
      json.donate_grants self.donate_record_builder
      json.grants do
        json.array! self.gsh_child_grants.granted.reverse_sorted do |grant|
          json.(grant, :id)
          json.(grant, :amount)
          json.reporter grant.grant_person
          json.content grant.grant_remark
          json.reported_at grant.granted_at.strftime("%Y-%m-%d")
          json.report_images do
            json.array! grant.images do |img|
              json.id img.id
              json.thumb img.file_url(:small)
              json.src img.file_url
              json.w img.width
              json.h img.height
            end
          end
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

  def child_info_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.name self.name
      json.age self.age
      json.level self.enum_name(:level)
      json.gsh_no self.gsh_no
      json.location [self.province, self.city, self.district]
      json.avatar self.avatar.present? ? self.avatar_url(:tiny).to_s : ''
    end.attributes!
  end

  def list_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :age, :reason)
      json.level_name self.enum_name(:level)
      json.id_card self.secure_id_card
      json.gender self.enum_name(:gender)
    end.attributes!
  end

  def pair_feedback_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :id_card)
      # json.id_card self.secure_id_card
    end.attributes!
  end

  def pair_visit_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :age)
      json.id_card self.secure_id_card
    end.attributes!
  end

  def donate_children_builder
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.gsh_no self.gsh_no
      json.child_id self.id
      json.grants self.semesters.where(user_id: self.donate_user_id).pluck(:title).join('/').gsub(/\s/, '').strip.to_s
      json.donate_state self.semesters.pending.size > 0
      json.num self.continual_feedbacks.count
      json.avatar self.avatar.present? ? self.avatar_url(:tiny).to_s : ''
    end.attributes!
  end

  def secure_id_card
    card = self.id_card
    return card[0] + '*' * (card.length - 2) + card[-1]
  end

  def pair_record_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.school_name self.school.try(:name)
      json.donate_grants self.donate_record_builder
    end.attributes!
  end

  def granted_record_builder
    Jbuilder.new do |json|
      json.array! self.donate_all_records.granted do |grant|
        json.(grant, :id)
        json.(grant, :title)
        json.(grant, :amount)
        json.school_name grant.school.try(:name)
        json.donate_state grant.donate_state
        json.note_count grant.thank_notes.count
      end
    end.attributes!
  end

  def donate_record_builder
    Jbuilder.new do |json|
      json.array! self.donate_all_records do |grant|
        json.(grant, :id)
        json.(grant, :title)
        json.(grant, :amount)
        json.school_name grant.school.try(:name)
        json.donate_state grant.donate_state
        json.note_count grant.thank_notes.count
      end
    end.attributes!
  end

  def whole_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :id_card, :teacher_name, :teacher_phone, :description, :father, :father_job, :mother, :mother_job, :guardian, :guardian_relation, :guardian_phone, :address, :family_income, :family_expenditure, :income_source, :family_condition, :brothers)
      json.level self.level
      json.nation self.nation
      json.grade self.grade
      json.semester self.semester
      json.avatar do
        json.id self.try(:avatar).try(:id)
        json.url self.try(:avatar).try(:file_url)
        json.protect_token self.try(:avatar).try(:protect_token)
      end
      json.id_image do
        json.id self.try(:id_image).try(:id)
        json.url self.try(:id_image).try(:file_url)
        json.protect_token self.try(:id_image).try(:protect_token)
      end
      json.residence do
        json.id self.try(:residence).try(:id)
        json.url self.try(:residence).try(:file_url)
        json.protect_token self.try(:residence).try(:protect_token)
      end
      json.poverty do
        json.id self.try(:poverty).try(:id)
        json.url self.try(:poverty).try(:file_url)
        json.protect_token self.try(:poverty).try(:protect_token)
      end
      json.family_image do
        json.id self.try(:family_image).try(:id)
        json.url self.try(:family_image).try(:file_url)
        json.protect_token self.try(:family_image).try(:protect_token)
      end
    end.attributes!
  end

  def can_update_pair_state?
    (self.pass? || self.reject?) && (self.apply.children.submit.count == 1)
  end

  def update_pair_state
    self.apply.pair_complete!
  end

  protected

  def create_gsh_child
    gsh_child = GshChild.new
    gsh_child.province = self.province
    gsh_child.city = self.city
    gsh_child.district = self.district
    gsh_child.name = self.name
    gsh_child.phone = self.phone
    gsh_child.qq = self.qq
    gsh_child.id_card = self.id_card
    gsh_child.save
    return gsh_child
  end


  def gen_grant_record
    GshChildGrant.gen_grant_record(self)
  end

  private
  def gen_gsh_no
    self.gsh_no ||= Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 10)
  end
end
