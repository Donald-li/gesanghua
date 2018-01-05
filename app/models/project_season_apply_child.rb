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
#

class ProjectSeasonApplyChild < ApplicationRecord

  require 'custom_validators'

  attr_accessor :image_ids
  include HasAsset
  has_many_assets :images, class_name: 'Asset::ApplyChildImage'

  belongs_to :project
  belongs_to :project_season
  belongs_to :project_season_apply
  belongs_to :gsh_child, optional: true
  has_many :audits, as: :owner
  has_many :remarks, as: :owner

  validates :id_card, ShenfenzhengNo: true
  validates :id_card, :name, :phone, presence: true
  validates :province, :city, :district, presence: true

  enum state: {show: 1, hidden: 2} # 状态：1:展示 2:隐藏
  default_value_for :state, 1
  enum approve_state: {submit: 1, pass: 2, rejected: 3} # 状态：1:待审核 2:通过 3:不通过
  default_value_for :approve_state, 1
  enum gender: {male: 1, female: 2,} # 状态：1:男 2:女
  default_value_for :gender, 1
  enum level: {junior: 1, senior: 2} # 状态：1:初中 2:高中
  default_value_for :level, 1
  enum grade: {gradeone: 1, gragetwo: 2, gradethree: 3} # 状态：1:一年级 2:二年级, 3:三年级
  default_value_for :grade, 1
  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56 }
  default_value_for :nation, 0


  scope :sorted, ->{ order(created_at: :desc) }

end
