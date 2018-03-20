# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                :integer          not null, primary key
#  project_id        :integer                                # 关联项目id
#  project_season_id :integer                                # 关联项目执行年度的id
#  school_id         :integer                                # 关联学校id
#  teacher_id        :integer                                # 负责项目的老师id
#  describe          :text                                   # 描述、申请要求
#  province          :string                                 # 省
#  city              :string                                 # 市
#  district          :string                                 # 区/县
#  state             :integer          default("show")       # 状态：1:展示 2:隐藏
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  name              :string                                 # 名称
#  number            :integer                                # 配额
#  apply_no          :string                                 # 项目申请编号
#  bookshelf_type    :integer                                # 悦读项目申请类型
#  contact_name      :string                                 # 联系人姓名
#  contact_phone     :string                                 # 联系人电话
#  audit_state       :integer                                # 审核状态
#  abstract          :string                                 # 简述
#  address           :string                                 # 详细地址
#  girl_number       :integer                                # 申请女生人数
#  boy_number        :integer                                # 申请男生人数
#  consignee         :string                                 # 收货人
#  consignee_phone   :string                                 # 收货人联系电话
#  target_amount     :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  execute_state     :integer          default(NULL)         # 执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成
#  project_type      :integer          default("apply")      # 项目类型:1:申请 2:筹款项目
#  class_number      :integer                                # 申请班级数
#  student_number    :integer                                # 受益学生数
#  project_describe  :text                                   # 项目介绍
#  form              :jsonb                                  # 自定义表单{key, value}
#  pair_state        :integer                                # 结对审核状态
#  code              :string                                 # code
#  read_state        :integer                                # 悦读项目状态
#

# 所有项目年度申请表
class ProjectSeasonApply < ApplicationRecord

  # before_save :gen_bookshelves_no, if: :can_gen_bookshelf_no?
  before_create :gen_apply_no

  attr_accessor :cover_image_id
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ProjectSeasonApplyImage'
  has_one_asset :cover_image, class_name: 'Asset::ProjectSeasonApplyCover'

  belongs_to :project
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :school, optional: true
  belongs_to :teacher, optional: true
  has_many :audits, as: :owner
  has_many :children, class_name: "ProjectSeasonApplyChild"
  has_many :gsh_child_grants
  has_many :gsh_children, class_name: 'ProjectSeasonApplyChild', dependent: :destroy
  has_many :bookshelves, ->{ order(id: :asc) }, class_name: 'ProjectSeasonApplyBookshelf', foreign_key: 'project_season_apply_id'
  has_many :supplements, ->{ order(id: :asc) }, class_name: 'BookshelfSupplement', foreign_key: 'project_season_apply_id'
  has_many :beneficial_children
  has_many :donate_records

  has_one :install_feedback, as: :owner
  has_one :receive_feedback, as: :owner
  has_one :radio_information
  accepts_nested_attributes_for :radio_information, update_only: true
  accepts_nested_attributes_for :bookshelves, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :supplements, allow_destroy: true, reject_if: :all_blank #proc { |attributes| attributes['project_season_apply_bookshelf_id'].blank? }

  default_value_for :form, {}
  attr_accessor :approve_remark

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏
  default_value_for :state, 2

  enum execute_state: {raising: 1, to_delivery: 2, to_receive: 3, to_feedback: 4, feedbacked: 5, done: 6, cancelled: 7} # 执行状态：1:筹款中 2:筹款完成 3:待收货 4:待反馈 5:已反馈 6:已完成 7:已取消
  default_value_for :execute_state, 1

  enum project_type: {apply: 1, raise_project: 2} # 筹款类型：1:申请 2:筹款项目
  default_value_for :project_type, 1

  scope :sorted, ->{ order(created_at: :desc) }

  enum audit_state: {submit: 1, pass: 2, reject: 3}#审核状态 1:待审核 2:审核通过 3:审核不通过
  default_value_for :audit_state, 1

  enum pair_state: {waiting_upload: 1, waiting_check: 2, pair_complete: 3}
  default_value_for :pair_state, 1

  enum read_state: {read_executing: 1, read_done: 2}
  default_value_for :read_state, 1

  enum bookshelf_type: {whole: 1, supplement: 2}
  # default_value_for :bookshelf_type, 1

  before_create :gen_code

  # def can_gen_bookshelf_no?
  #   self.raise_project?
  # end

  def apply_name
    self.season.try(:name).to_s + '-' + self.school.try(:name).to_s
  end

  def pass_bookshelf?
    if self.bookshelves.pass.present? || self.supplements.pass.present?
      true
    else
      false
    end
  end

  # 判断学校是否可以申请本批次
  def self.allow_apply?(school, season)
    return false if season.nil?
    return false if season.project.platform_assign?
    if self.season_apply_count(school, season) > 0
      return false
    else
      return true
    end
  end

  def self.season_apply_count(school=nil, season=nil)
    scope = self.where(season: season)
    scope = scope.where(school: school) if school.present?
    scope.count
  end

  def self.address_group(project_id)
    Jbuilder.new do |json|
      json.city self.city_group(project_id)
    end.attributes!
  end

  def self.city_group(project_id)
    self.show.where(project_id: project_id).map{|apply| apply.school}.group_by {|school| school.city}.keys.map {|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key, project_id)}}
  end

  def self.district_group(city, project_id)
    School.where(id: self.show.where(project_id: project_id).pluck(:school_id), city: city).group_by {|school| school.district}.keys.map {|key| {value: key, name: ChinaCity.get(key)}}
  end

  # 项目是否可以退款
  def can_refund?
    self.pass? && self.raise_project? && (self.raising? || self.canceled?)
  end

  # 生成图书角编号
  # def gen_bookshelves_no
  #   self.bookshelves.pass.each do |b|
  #     b.gen_bookshelf_no
  #     b.save
  #   end
  # end

  # 通过审核的补书申请数量
  def supplements_count
    self.supplements.pass.count
  end

  # 筹款完成的补书数量
  def supplements_done_count
    self.supplements.pass_done.count
  end

  # 通过审核的班级数量
  def bookshelves_count
    self.bookshelves.pass.count
  end

  # 筹款完成的班级数量
  def bookshelves_done_count
    self.bookshelves.pass_done.count
  end

  default_value_for :class_number, 0
  default_value_for :student_number, 0

  # 通过审核
  def audit_pass
    self.audit_state = 'pass'
    self.save
  end

  # 审核不通过
  def audit_reject
    self.audit_state = 'reject'
    self.save
  end

  def apply_state
    if self.apply?
      if self.submit?
        '待审核'
      elsif self.pass?
        '审核完成'
      elsif self.reject?
        '审核未通过'
      end
    elsif self.raise_project?
      if self.project == Project.read_project
        self.enum_name(:read_state)
      else
        if self.done?
          '已完成'
        elsif self.cancelled?
          '已取消'
        else
          '执行中'
        end
      end
    end
  end

  # 完整的地址
  def receive_address
    province = ChinaCity.get(self.province).to_s
    city = ChinaCity.get(self.city).to_s
    district = ChinaCity.get(self.district).to_s
    return province + city + district + self.address.to_s
  end

  def sliced_abstract
    self.abstract && self.abstract.length > 90 ? self.abstract.slice(0..90) : self.abstract
  end

  def match_donate(params, amount, *args) # platform
    child_id = args.first || nil
    apply = self
    if params[:donate_way] == 'offline'
      user = User.find(params[:user_id])
      donate_record = DonateRecord.new(params.merge(project_season_apply_child_id: child_id, fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, donor: user.name, remitter_id: user.id, remitter_name: user.name, season: apply.season, apply: apply, kind: 'custom'))
    elsif params[:donate_way] == 'match'
      match_fund = Fund.find(params[:match_fund_id])
      match_fund.amount -= amount.to_f
      return false if match_fund.amount < 0
      donate_record = DonateRecord.new(params.merge(project_season_apply_child_id: child_id, fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, season: apply.season, apply: apply, kind: 'custom'))
    elsif params[:donate_way] == 'balance'
      user = User.find(params[:balance_id])
      user.balance -= amount
      return false if user.balance < 0
      donate_record = DonateRecord.new(params.merge(project_season_apply_child_id: child_id, fund: apply.project.fund, pay_state: 'paid', amount: amount, project: apply.project, donor: user.name, remitter_id: user.id, remitter_name: user.name, season: apply.season, apply: apply, kind: 'custom'))
    end
    income_record = IncomeRecord.new(donate_record: donate_record, user: donate_record.user, fund: donate_record.fund, amount: amount, remitter_id: donate_record.remitter_id, remitter_name: donate_record.remitter_name, donor: donate_record.donor, promoter_id: donate_record.promoter_id, income_time: Time.now)
    income_record.income_source_id = params[:source_id]
    self.transaction do
      begin
        donate_record.save && income_record.save
        match_fund.save if match_fund.present?
        user.save if user.present?
        return true
      rescue
        return false
      end
    end
    return false
  end

  # 动态表单内容的builder
  def form_builder
    project = self.project
    Jbuilder.new do |json|
      json.array!(project.form) do |item|
        json.label item['label']
        json.key item['key']
        json.value self.form[item['key']] || ''
      end
    end.attributes!
  end

  # 基础信息, 列表展示用
  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :apply_no, :target_amount, :present_amount, :bookshelf_type)
      json.name self.apply_name
      json.last_amount self.target_amount - self.present_amount
      json.cover_mode self.cover_image.present?
      json.cover_url self.cover_image_url(:small).to_s
    end.attributes!
  end

  # 详细信息, 详情展示用
  def detail_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
      json.(self, :number, :describe, :target_amount, :present_amount, :class_number, :student_number)
      json.name self.apply_name
      json.school_name self.school.try(:name)
      json.season_name self.season.try(:name)
      json.state self.enum_name(:pair_state)
      json.created_at self.created_at.strftime("%Y-%m-%d")
    end.attributes!
  end

  # 申请信息的builder,联系人等
  def apply_base_builder
    Jbuilder.new do |json|
      json.season [self.season.id.to_s]
      json.contact_name self.contact_name
      json.contact_phone self.contact_phone
      json.location [self.province, self.city, self.district]
      json.address self.address
      json.receive_address self.receive_address
      json.apply_state self.apply_state
    end.attributes!
  end

  # 一对一
  def pair_applies_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.teacher self.teacher.try(:name)
    end.attributes!
  end

  ## 悦读，待优化
  # 悦读申请信息
  def read_applies_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.bookshelf_type self.bookshelf_type == 'whole'? '新图书角' : '图书角补书'
      json.teacher self.teacher.present? ? self.teacher.try(:name) : self.contact_name
      json.merge! apply_base_builder
    end.attributes!
  end

  # 悦读申请摘要
  def read_apply_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :apply_no)
      json.last_amount self.target_amount - self.present_amount
      json.total_count self.bookshelves.pass.count
      json.done_count self.bookshelves.pass.to_delivery.count
      json.cover_mode self.cover_image.present?
      json.cover_url self.cover_image_url(:small).to_s
    end.attributes!
  end

  # 悦读项目表单
  def read_apply_submit_form_summary_builder
    Jbuilder.new do |json|
      json.season [self.season.id.to_s]
      json.dynamic_form self.form
      json.class_number self.class_number
      json.student_number self.student_number
      json.contact_name self.contact_name
      json.contact_phone self.contact_phone
      json.location [self.province, self.city, self.district]
      json.receive_address self.receive_address
      json.address self.address
      json.describe self.describe
    end.attributes!
  end

  def read_supply_receive_info_summary_builder
    Jbuilder.new do |json|
      json.id self.id
      json.contact_name self.contact_name
      json.contact_phone self.contact_phone
      json.location [self.province, self.city, self.district]
      json.address self.address
    end.attributes!
  end

  # 悦读详情展示
  def read_detail_builder
    Jbuilder.new do |json|
      json.merge! self.detail_builder
      json.(self, :bookshelf_type, :project_describe)
      json.season_name self.season.name
      json.donate_items self.bookshelves.map{|b| b.summary_builder} if self.whole?
      json.donate_items self.supplements.map{|b| b.summary_builder} if self.supplement?
      json.describe self.describe
      json.merge! apply_base_builder
    end.attributes!
  end

  ## 广播项目申请表单
  def radio_apply_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.teacher self.teacher.present? ? self.teacher.try(:name) : self.contact_name
      json.form self.form
      json.form_submit self.form_builder
      json.describe self.describe
      json.merge! apply_base_builder
    end.attributes!
  end

  # 广播项目列表
  def radio_summary_builder
    self.summary_builder
  end

  # 广播项目详情
  def radio_detail_builder
    self.detail_builder
  end

  ## 护花申请表单
  def care_apply_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.teacher self.teacher.present? ? self.teacher.try(:name) : self.contact_name
      json.form self.form
      json.form_submit self.form_builder
      json.describe self.describe
      json.merge! apply_base_builder
    end.attributes!
  end

  # 护花项目列表
  def care_summary_builder
    self.summary_builder
  end

  # 护花项目详情
  def care_detail_builder
    self.detail_builder
  end

  # 护花课程表单
  def movie_care_apply_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.teacher self.teacher.present? ? self.teacher.try(:name) : self.contact_name
      json.form self.form
      json.form_submit self.form_builder
      json.describe self.describe
      json.merge! apply_base_builder
    end.attributes!
  end

  # 护花课程项目列表
  def movie_care_summary_builder
    self.summary_builder
  end

  # 护花课程项目详情
  def movie_care_detail_builder
    self.detail_builder
  end

  # 观影课程表单
  def movie_apply_builder
    Jbuilder.new do |json|
      json.merge! detail_builder
      json.teacher self.teacher.present? ? self.teacher.try(:name) : self.contact_name
      json.form self.form
      json.form_submit self.form_builder
      json.describe self.describe
      json.merge! apply_base_builder
    end.attributes!
  end

  # 观影课程项目列表
  def movie_summary_builder
    self.summary_builder
  end

  # 观影课程项目详情
  def movie_detail_builder
    self.detail_builder
  end

  private
  def gen_apply_no
    if self.project_id == Project.pair_project.id
      kind = 'JD'
    elsif self.project_id == Project.read_project.id || self.project_id == Project.book_supply_project.id
      kind = 'YD'
    elsif self.project_id == Project.movie_project.id
      kind = 'GY'
    elsif self.project_id == Project.camp_project.id
      kind = 'TS'
    elsif self.project_id == Project.radio_project.id
      kind = 'GB'
    elsif self.project_id == Project.care_project.id || self.project_id == Project.movie_care_project.id
      kind = 'HH'
    else
      kind = 'QT'
    end
    self.apply_no ||= Sequence.get_seq(kind: :apply_no, prefix: kind, length: 7)
  end

  def gen_code
    loop do
      code = SecureRandom.base58
      child = ProjectSeasonApply.find_by(code: code)
      unless child.present?
        self.code = code
        break
      end
    end
  end

end
