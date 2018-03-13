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
#  student_number          :integer                                # 班级学生人数
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

  scope :gsh_bookshelf, -> { complete }

  validates :classname, presence: true

  enum audit_state: {submit: 1, pass: 2, reject: 3}
  default_value_for :audit_state, 1

  enum show_state: {show: 1, hidden: 2}
  default_value_for :show_state, 1

  enum state: {pending: 1, complete: 2, non_execution: 3, non_reception: 4, non_feedback: 5, done: 6}
  default_value_for :state, 1

  enum grade: {juniorone: 1, juniortwo: 2, juniorthree: 3, seniorone: 4, seniortwo: 5, seniorthree: 6}
  default_value_for :grade, 1

  scope :pass_done, ->{ pass.done }

  scope :sorted, ->{ order(created_at: :desc) }

  def name
    self.classname
  end

  def can_gen_bookshelf_no?
    self.complete?
  end

  def self.address_group
    Jbuilder.new do |json|
      json.city self.city_group
    end.attributes!
  end

  def self.city_group
    self.show.group_by {|item| item.school.city}.keys.map {|key| {value: key, name: ChinaCity.get(key), district: self.district_group(key)}}
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

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :classname, :bookshelf_no, :book_number)
      json.apply_name self.apply.name
      json.title self.show_title
      json.image self.try(:image).try(:file_url)
    end.attributes!
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :classname, :title, :bookshelf_no, :target_amount, :present_amount, :state)
      json.grade self.enum_name(:grade)
    end.attributes!
  end

  def class_summary_builder
      Jbuilder.new do |json|
        json.(self, :id, :classname, :student_number)
      end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.merge! summary_builder
    end.attributes!
  end

  private
  def gen_bookshelf_no
    self.bookshelf_no ||= Sequence.get_seq(kind: :bookshelf_no, prefix: 'TSJ1', length: 3)
  end

end
