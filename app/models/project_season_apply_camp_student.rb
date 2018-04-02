# == Schema Information
#
# Table name: project_season_apply_camp_students # 探索营学生
#
#  id                           :integer          not null, primary key
#  name                         :string                                 # 姓名
#  id_card                      :string                                 # 身份证号
#  nation                       :integer                                # 民族
#  gender                       :integer                                # 性别
#  school_id                    :integer                                # 学校id
#  project_season_apply_camp_id :integer                                # 探索营配额id
#  camp_id                      :integer                                # 探索营id
#  project_season_apply_id      :integer                                # 营立项id
#  grade                        :integer                                # 年级
#  level                        :integer                                # 初高中
#  teacher_name                 :string                                 # 老师姓名
#  teacher_phone                :string                                 # 老师联系方式
#  guardian_name                :string                                 # 监护人姓名
#  guardian_phone               :string                                 # 监护人联系方式
#  description                  :text                                   # 自我介绍
#  reason                       :string                                 # 推荐理由
#  state                        :integer                                # 状态
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  age                          :integer                                # 年龄
#

class ProjectSeasonApplyCampStudent < ApplicationRecord

  belongs_to :school
  belongs_to :camp
  belongs_to :apply_camp, class_name: 'ProjectSeasonApplyCamp', foreign_key: :project_season_apply_camp_id
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id

  enum state: {submit: 1, pass: 2, reject: 3}
  default_value_for :state, 1

  enum gender: {male: 1, female: 2, } # 状态：1:男 2:女
  default_value_for :gender, 1

  enum level: {junior: 1, senior: 2} # 状态：1:初中 2:高中
  default_value_for :level, 1

  enum grade: {one: 1, two: 2, three: 3} # 年级：1:一年级 2:二年级, 3:三年级
  default_value_for :grade, 1

  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56}
  default_value_for :nation, 0

  validates :name, :id_card, :teacher_name, :teacher_phone, :description, presence: true
  scope :sorted, ->{ order(created_at: :asc) }

end
