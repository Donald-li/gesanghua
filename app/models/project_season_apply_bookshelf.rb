# == Schema Information
#
# Table name: project_season_apply_bookshelves # 项目执行年度申请书架表
#
#  id                      :integer          not null, primary key
#  project_id              :integer                                # 关联项目id
#  project_season_id       :integer                                # 关联项目执行年度id
#  project_season_apply_id :integer                                # 关联项目执行年度申请id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  school_id               :integer                                # 学校id
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  audit_state             :integer                                # 审核状态 1:提交 2:通过 3:拒绝
#  show_state              :integer                                # 显示状态 1:显示 2:隐藏
#  state                   :integer                                # 筹款状态:
#  grade                   :integer                                # 年级
#  bookshelf_no            :string                                 # 图书角编号
#  target_amount           :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount          :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  book_number             :integer                                # 书籍数量
#  student_number          :integer                                # 班级人数
#  contact_name            :string                                 # 联系人
#  contact_phone           :string                                 # 联系电话
#  address                 :string                                 # 详细地址
#

# 项目年度图书角申请
class ProjectSeasonApplyBookshelf < ApplicationRecord

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::BookshelfImage'

  before_save :gen_bookshelf_no, if: :can_gen_bookshelf_no?

  belongs_to :project, optional: true
  belongs_to :season, class_name: 'ProjectSeason', foreign_key: 'project_season_id', optional: true
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: 'project_season_apply_id', optional: true
  belongs_to :school, optional: true

  has_many :donates, class_name: 'DonateRecord', dependent: :destroy
  has_many :beneficial_children
  has_many :supplements, class_name: 'BookshelfSupplement', foreign_key: 'project_season_apply_bookshelf_id'
  has_one :receive_feedback, as: :owner
  has_one :install_feedback, as: :owner
  has_one :logistic, as: :owner

  scope :gsh_bookshelf, -> { to_delivery }

  validates :classname, presence: true

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {raising: 1, to_delivery: 2, to_receive: 3, to_feedback: 4, feedbacked: 5, done: 6, cancelled: 7} # 筹款状态 1:筹款中 2:待发货 3:待收货 4:待反馈 5:反馈完成 6:完成 7:取消
  default_value_for :state, 1

  enum grade: {juniorone: 1, juniortwo: 2, juniorthree: 3, seniorone: 4, seniortwo: 5, seniorthree: 6}
  default_value_for :grade, 1

  scope :pass_done, ->{ where(state: ['feedbacked', 'done']) }

  scope :sorted, ->{ order(created_at: :asc) }

  # counter_culture :apply, column_name: proc{|model| model.to_receive? ? 'present_amount' : nil}, delta_magnitude: proc {|model| model.present_amount }

  # 使用捐助
  def accept_donate(donate_records)
    donate_record = donate_records.last

    amount = [surplus_money, donate_record.amount].min
    donate_record.update!(amount: amount)

    self.present_amount += amount
    self.apply.present_amount += amount
    self.project.appoint_fund.balance += amount

    self.state = 'to_delivery' if self.present_amount >= self.target_amount
    self.save!
    self.apply.save!
  end

  def surplus_money
    self.target_amount - self.present_amount
  end

  def pass_done?
    self.feedbacked? || self.done?
  end

  def name
    self.classname
  end

  def can_gen_bookshelf_no?
    self.to_delivery?
  end

  def self.address_group
    Jbuilder.new do |json|
      json.city self.city_group
    end.attributes!
  end

  def self.city_group
    cities = self.show.pluck('distinct city').compact
    cities.map{|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
  end

  def self.district_group(city)
    School.where(id: self.show.pluck(:school_id), city: city).group_by {|item| item.district}.keys.map {|key| {value: key, name: ChinaCity.get(key)}}
  end

  def show_title
    if self.title.present?
      return self.title
    else
      return self.classname
    end
  end

  def json_show_state
    if self.apply.present? && self.apply.raise_project?
      self.enum_name(:state)
    else
      self.enum_name(:audit_state)
    end
  end

  # 图书角图片
  def bookshelf_image
    self.try(:image).try(:file_url) || self.project.project_image
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :classname, :title, :bookshelf_no, :student_number, :book_number, :target_amount, :present_amount, :state)
      json.surplus_money self.surplus_money
      json.apply_name self.apply.name
      json.title self.show_title
      json.image bookshelf_image
      json.grade self.enum_name(:grade)
    end.attributes!
  end

  def class_summary_builder
      Jbuilder.new do |json|
        json.(self, :id, :classname, :student_number)
      end.attributes!
  end

  def apply_builder
    Jbuilder.new do |json|
      json.(self, :id, :classname, :student_number)
    end.attributes!
  end

  def class_list_summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :bookshelf_no, :target_amount, :present_amount)
      json.apply_name self.apply.try(:name)
      json.title self.show_title
      json.state self.json_show_state
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
    end.attributes!
  end

  def self.clear_garbage
    self.where(project_season_id: nil, project_season_apply_id: nil).destroy_all
  end

  private
  def gen_bookshelf_no
    self.bookshelf_no ||= Sequence.get_seq(kind: :bookshelf_no, prefix: 'TSJ1', length: 3)
  end

end
