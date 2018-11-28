# == Schema Information
#
# Table name: project_season_apply_children # 项目执行年度申请的孩子表
#
#  id                      :bigint(8)        not null, primary key
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
#  donate_user_id          :integer                                # 捐助人id
#  reason                  :string                                 # 结对申请理由
#  gsh_no                  :string                                 # 格桑花孩子编号
#  semester_count          :integer                                # 学期数
#  done_semester_count     :integer          default(0)            # 已完成的学期数
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
#  remark                  :text                                   # 备注
#  expenditure_information :text                                   # 支出详情
#  debt_information        :text                                   # 负债情况
#  parent_information      :string                                 # 父母情况
#  information             :text                                   # 对外展示的孩子介绍
#  classname               :string                                 # 班级名称
#  priority_id             :integer                                # 优先捐助人id
#  archive_data            :jsonb                                  # 归档旧数据
#  student_state           :integer          default("normal")     # 学生状态
#

require 'custom_validators'
class ProjectSeasonApplyChild < ApplicationRecord

  include SanitizeContent
  sanitize_content :information

  has_paper_trail only: [:project_id, :project_season_id, :project_season_apply_id, :gsh_child_id, :name, :province, :city, :district, :phone, :qq, :nation, :id_card, :parent_name, :description, :state,
                         :approve_state, :age, :level, :grade, :gender, :school_id, :semester, :kind, :reson, :gsh_no, :teacher_name, :teacher_phone, :father, :father_job, :mother, :mother_job, :guardian, :guardian_relation, :guardian_phone, :address,
                         :family_income, :family_expenditure, :income_source, :family_condition, :brothers, :remark]

  after_save :distinguish_gender, :count_age, :update_gsh_child
  before_update :update_pair_state, if: :can_update_pair_state?
  before_save :save_change_to_gsh_child

  attr_accessor :avatar_id
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ApplyChildImage'
  has_one_asset :avatar, class_name: 'Asset::ApplyChildAvatar' # 前台上传的个人照片作为孩子头像
  has_one_asset :id_image, class_name: 'Asset::ApplyChildIdCard'
  has_one_asset :poverty, class_name: 'Asset::ApplyChildPoverty'
  has_one_asset :room_image, class_name: 'Asset::ApplyChildRoomImage'
  has_one_asset :yard_image, class_name: 'Asset::ApplyChildYardImage'
  has_one_asset :apply_one, class_name: 'Asset::ApplyChildApplyImage'
  has_one_asset :apply_two, class_name: 'Asset::ApplyChildApplyAnotherImage'
  has_one_asset :apply_child_excel, class_name: 'Asset::ApplyChildExcel'

  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id'
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id'
  belongs_to :gsh_child, optional: true
  belongs_to :school
  belongs_to :user, optional: true
  has_many :visits, foreign_key: 'apply_child_id', dependent: :destroy
  has_many :audits, as: :owner, dependent: :destroy
  has_many :remarks, as: :owner, dependent: :destroy
  has_many :complaints, as: :owner, dependent: :destroy
  has_many :donates, class_name: 'DonateRecord', dependent: :restrict_with_error, as: :owner #TODO: 待检查
  has_many :gsh_child_grants, dependent: :destroy
  #FIXME: 跟上面的关系重复了？
  has_many :semesters, class_name: 'GshChildGrant', dependent: :destroy
  has_many :feedbacks, as: :owner, dependent: :destroy
  has_many :continual_feedbacks, dependent: :destroy

  has_many :period_child_ships, dependent: :destroy
  has_many :project_season_apply_periods, through: :period_child_ships
  accepts_nested_attributes_for :project_season_apply_periods
  accepts_nested_attributes_for :audits

  attr_accessor :approve_remark

  validates :id_card, shenfenzheng_no: true, if: ->(c) {c.archive_data.blank?}
  validates :id_card, :name, presence: true, if: ->(c) {c.archive_data.blank?}
  validates :province, :city, :district, presence: true, if: ->(c) {c.archive_data.blank?}
  validates :reason, length: {maximum: 200}

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏
  default_value_for :state, 2
  enum student_state: {abnormal: -1, normal: 0, finish: 1} # 状态：-1:异常 0:正常 1:结束

  enum approve_state: {draft: 0, submit: 1, pass: 2, reject: 3} # 状态：1:待审核 2:通过 3:不通过
  default_value_for :approve_state, 0

  enum gender: {unknow: 0, male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 0

  # enum level: {junior: 1, senior: 2} # 状态：1:初中 2:高中
  enum level: {primary: 0, junior: 1, senior: 2, abbreviation: 4} # 学校等级：0小学 1:初中 2:高中 4职高
  default_value_for :level, 1

  enum kind: {outside: 1, inside: 2} # 捐助形式：1:对外捐助 2:内部认捐
  default_value_for :kind, 1

  enum grade: {one: 1, two: 2, three: 3, four: 4, five: 5, six: 6} # 年级：1:一年级 2:二年级, 3:三年级
  default_value_for :grade, 1

  enum semester: {last_term: 1, next_term: 2} # 学期： 1:上学期 2:下学期
  default_value_for :semester, 1
  default_value_for :information, ''

  default_value_for :archive_data, {}

  enum nation: {'default': 0, 'hanzu': 1, 'zangzu': 10, 'huizu': 4, 'tuzu': 30, 'mengguzu': 9, 'salazu': 37, 'zhuangzu': 2, 'manzu': 3, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56}
  default_value_for :nation, 0

  scope :sorted, -> {order(created_at: :desc)}
  scope :reverse_sorted, -> {order(created_at: :asc)}
  scope :can_batch_update, -> {pass.where(student_state: ['normal'])}
  scope :check_list, -> {where(approve_state: [1, 2, 3])}

  def self.allow_apply?(school, id_card, child=nil)
    return true if child.try(:archive_data).present?
    return false unless id_card.present?
    if child.nil?
      return false if self.where(school: school, id_card: id_card).present?
      return true
    else
      return false if self.where.not(id: child.id).where(school: school, id_card: id_card).present?
      return true
    end
  end

  def child_avatar
    self.avatar.try(:file_url, :tiny)
  end

  def count_donate_amount_by_grant_number(number)
    count = 0
    self.get_donate_items.each_with_index do |item, index|
      if index < number
        count += item.amount
      else
        break
      end
    end
    return count
  end

  def self.read_excel(excel_id, project_apply)
    file = Asset.find(excel_id).try(:file).try(:file)
    FileUtil.import_pair_students(original_filename: file.original_filename, path: file.path, project_apply: project_apply) if file.present?
  end

  def self.excel_template
    '/excel/templates/结对学生导入模板.xlsx'
  end

  # 得到可捐助子项
  def get_donate_items
    self.semesters.pending.order(id: :asc)
  end

  def level_name
    {primary: 0, junior: 1, senior: 2, abbreviation: 4}
    if self.primary?
      '小'
    elsif self.junior?
      '初'
    elsif self.senior?
      '高'
    elsif self.abbreviation?
      '职'
    end
  end

  def grade_name
    if self.one?
      '一'
    elsif self.two?
      '二'
    elsif self.three?
      '三'
    elsif self.four?
      '四'
    elsif self.five?
      '五'
    elsif self.six?
      '六'
    end

  end

  # 更新申请状态
  def check_state
    self.done_semester_count = self.semesters.succeed.count
  end

  def priority_user
    User.find(self.priority_id) if self.priority_id.present?
  end

  def gsh_no
    self.gsh_child.try(:gsh_no)
  end

  def child_birthday
    if self.id_card.present?
      year = self.id_card.slice(6, 4)
      month = self.id_card.slice(10, 2)
      day = self.id_card.slice(12, 2)
      return "#{month}月#{day}日生"
    end
  end

  def count_age
    return unless self.id_card.present?
    birthday = ChinesePid.new("#{self.id_card}").birthday
    today = Date.today
    child_age = (today - birthday).to_i/365
    self.update_columns(age: child_age)
  end

  def distinguish_gender
    pid_gender = ChinesePid.new("#{self.id_card}").gender
    gender = :male if pid_gender == 1
    gender = :female if pid_gender == 0
    self.update_columns(gender: gender)
  end

  def secure_name
    return '' if self.name.blank?
    if self.name.length < 2
      self.name
    else
      self.name.sub(self.name[1, 1], '*')
    end
  end

  def update_state(u_id)
    # self.done_semester_count = self.semesters.succeed.count
    self.state = 'hidden'
    self.kind = 'inside'
    self.priority_id = u_id
    self.save!
  end

  # 筹款进度
  def gift_progress
    "#{self.done_semester_count} / #{self.semester_count.to_i}"
  end

  def raise_condition
    total = self.semester_count
    num = self.done_semester_count
    if num == 0
      '筹款中'
    elsif num == total
      '筹款完成'
    else
      '可续捐'
    end
  end

  def can_continue?(user)
    self.semesters.pending.count > 0 && self.priority_id == user.id
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
    self.generate_qrcode unless File.exists?("public/uploads/qrcode/#{self.gsh_no}.png")
    "/uploads/qrcode/#{self.gsh_no}.png"
  end

  def share_url
    # Rails.application.routes.url_helpers.q_url(:host => Settings.app_host, child_id: self.id)
    "#{Settings.m_root_url}/pair/#{self.id}  欢迎参与格桑花结对助学项目" # TODO 前段路由定义以后修改为正确的路由
  end

  def share_path
    "#{Settings.m_root_url}/pair/#{self.id}"
  end

  # 通过审核
  def approve_pass
    if self.approve_state = 'pass' && self.save && self.gen_grant_record
      return true
    else
      return false
    end
  end

  def formatted_information
    self.information.present? ? self.information.gsub(/\r\n/, '<br>').gsub(/(<br\/*>\s*){1,}/, '<br>') : ''
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
      # json.avatar self.avatar_url(:tiny)
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
    self.outside.show.group_by {|child| child.city}.keys.map {|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
  end

  def self.district_group(city)
    self.outside.show.where(city: city).group_by {|child| child.district}.keys.map {|key| {value: key, name: ChinaCity.get(key)}}
  end

  def get_tuition
    if self.junior?
      return self.season.junior_year_amount
    else
      return self.season.senior_year_amount
    end
  end

  # 批量推送续捐消息
  def self.batch_push_notice
    ProjectSeasonApplyChild.pass.hidden.sorted.each do |child|
      user_id = child.priority_id
      pending_grants = child.semesters.pending
      if pending_grants.count > 0 && pending_grants.first.title.start_with?(Time.now.year) && user_id.present?
        Notification.create(
            kind: 'continue_donate',
            owner: child,
            user_id: user_id,
            title: "#续捐通知# 您有一个孩子待续捐",
            content: "您捐助过的#{child.name}新的学年助学款可以续捐了，请及时续捐",
            url: "#{Settings.m_root_url}/pair/#{child.id}"
        )
      end
    end
  end

  def self.update_priority_users
    ProjectSeasonApplyChild.pass.hidden.sorted.each do |child|
      child.update(priority_id: child.semesters.sorted.succeed.last.try(:user_id))
    end
  end

  # 受助学生的全部捐助记录
  def donate_all_records
    self.gsh_child_grants.sorted
  end

  # 受助学生未筹款的记录
  def donate_pending_records
    self.gsh_child_grants.pending.reverse_sorted
  end

  # 受助学生筹款成功的记录
  def donate_succeed_records
    self.gsh_child_grants.succeed.reverse_sorted
  end

  # 是否被用户认捐？
  def donate_by_user?(user)
    return false unless user
    self.priority_user == user || (self.priority_user.present? && self.priority_user == user.manager) || user.offline_users.unactived.pluck(:id).include?(self.priority_id) || donate_grants_by_user(user).exists?
  end

  # 用户捐助的学期
  def donate_grants_by_user(user)
    grant_ids = user.donate_records.where(owner_type: 'GshChildGrant', owner_id: self.gsh_child_grant_ids).pluck(:owner_id)
    self.gsh_child_grants.sorted.where(id: grant_ids)
  end

  #用于操作日志查找关系
  def project_season
    self.season
  end

  def project_season_apply
    self.apply
  end

  def summary_builder(user=nil)
    Jbuilder.new do |json|
      json.(self, :id, :father, :father_job, :mother, :mother_job, :classname, :guardian, :guardian_relation, :guardian_phone, :income_source, :family_income, :family_condition, :address, :reason)
      json.room_image self.room_image_url(:medium) if self.room_image
      json.yard_image self.yard_image_url(:medium) if self.yard_image
      json.name donate_by_user?(user) ? self.name : self.secure_name
      json.avatar donate_by_user?(user) ? self.avatar_url(:tiny) : nil
      json.donate_by_user donate_by_user?(user)
      json.description self.description
      json.age self.age
      json.gender self.enum_name(:gender)
      json.school self.school.try(:name)
      json.nation self.enum_name(:nation)
      json.level self.enum_name(:level)
      json.grade self.enum_name(:grade)
      json.gsh_no self.gsh_no
      json.birthday '| ' + self.child_birthday.to_s
      json.tuition self.get_tuition.to_i
      json.information self.formatted_information
      json.create_time self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      json.donate_grants self.donate_record_builder
      json.grants do # 发放记录
        json.array! self.gsh_child_grants.granted.sorted do |grant|
          json.(grant, :id)
          json.(grant, :amount)
          json.reporter grant.grant_person
          json.content grant.grant_remark
          json.reported_at grant.granted_at.strftime("%Y-%m-%d") if grant.granted_at.present?
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
      json.avatar child_avatar
    end.attributes!
  end

  def list_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :age, :reason)
      json.level_name self.enum_name(:level)
      json.id_card self.secure_id_card
      json.gender self.enum_name(:gender)
      json.visit_number self.visits.count
    end.attributes!
  end

  def manage_list_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :age, :reason, :id_card)
      json.level_name self.enum_name(:level)
      json.gender self.enum_name(:gender)
      json.visit_number self.visits.count
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

  def donate_children_builder(user)
    Jbuilder.new do |json|
      json.(self, :id, :name)
      json.gsh_no self.gsh_no
      json.child_id self.id
      json.donate_state self.can_continue?(user)
      json.avatar self.avatar_url(:tiny).to_s
      json.grants self.donate_grants_by_user(user).pluck(:title)
      json.feedbacks_count self.continual_feedbacks.uncheck.count
    end.attributes!
  end

  def secure_id_card
    card = self.id_card
    return unless card.present?
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
      json.array! self.donate_all_records.granted.reverse_order do |grant|
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
      json.array! self.donate_all_records.visible do |grant|
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
      json.(self, :id, :name, :id_card, :teacher_name, :classname, :teacher_phone, :description, :parent_information, :debt_information, :expenditure_information, :father, :father_job, :mother, :mother_job, :guardian, :guardian_relation, :guardian_phone, :address, :family_income, :family_expenditure, :income_source, :family_condition, :brothers)
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
      json.poverty do
        json.id self.try(:poverty).try(:id)
        json.url self.try(:poverty).try(:file_url)
        json.protect_token self.try(:poverty).try(:protect_token)
      end
      json.room_image do
        json.id self.try(:room_image).try(:id)
        json.url self.try(:room_image).try(:file_url)
        json.protect_token self.try(:room_image).try(:protect_token)
      end
      json.yard_image do
        json.id self.try(:yard_image).try(:id)
        json.url self.try(:yard_image).try(:file_url)
        json.protect_token self.try(:yard_image).try(:protect_token)
      end
      json.apply_one do
        json.id self.try(:apply_one).try(:id)
        json.url self.try(:apply_one).try(:file_url)
        json.protect_token self.try(:apply_one).try(:protect_token)
      end
      json.apply_two do
        json.id self.try(:apply_two).try(:id)
        json.url self.try(:apply_two).try(:file_url)
        json.protect_token self.try(:apply_two).try(:protect_token)
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
  def save_change_to_gsh_child
    return unless self.pass?
    if self.gsh_child.present?
      update_gsh_child
    else
      self.gsh_child = GshChild.find_by(id_card: self.id_card) || create_gsh_child
    end
  end

  def create_gsh_child
    gsh_child = GshChild.new
    gsh_child.province = self.province
    gsh_child.city = self.city
    gsh_child.district = self.district
    gsh_child.name = self.name
    gsh_child.phone = self.phone
    gsh_child.qq = self.qq
    gsh_child.id_card = self.id_card
    gsh_child.save(validate: false)
    return gsh_child
  end

  def update_gsh_child
    if self.pass?
      return unless self.gsh_child.present?
      gsh_child = self.gsh_child
      gsh_child.province = self.province
      gsh_child.city = self.city
      gsh_child.district = self.district
      gsh_child.name = self.name
      # gsh_child.phone = self.phone
      # gsh_child.qq = self.qq
      gsh_child.id_card = self.id_card
      gsh_child.save(validate: false)

    end
  end

  def gen_grant_record
    GshChildGrant.gen_grant_record(self)
  end
end
