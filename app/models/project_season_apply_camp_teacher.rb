# == Schema Information
#
# Table name: project_season_apply_camp_teachers # 探索营老师名单
#
#  id                           :integer          not null, primary key
#  name                         :string                                 # 姓名
#  id_card                      :string                                 # 身份证号
#  nation                       :integer                                # 民族
#  gender                       :integer                                # 性别
#  phone                        :string                                 # 联系方式
#  state                        :integer                                # 状态
#  school_id                    :integer                                # 学校id
#  project_season_apply_camp_id :integer                                # 探索营配额id
#  camp_id                      :integer                                # 探索营id
#  project_season_apply_id      :integer                                # 营立项id
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  age                          :integer                                # 年龄
#

class ProjectSeasonApplyCampTeacher < ApplicationRecord

  belongs_to :school
  belongs_to :camp
  belongs_to :apply_camp, class_name: 'ProjectSeasonApplyCamp', foreign_key: :project_season_apply_camp_id
  belongs_to :apply, class_name: 'ProjectSeasonApply', foreign_key: :project_season_apply_id

  enum state: {submit: 1, pass: 2, reject: 3}
  default_value_for :state, 1

  enum gender: {unknow: 0, male: 1, female: 2} #性别 1:男 2:女
  default_value_for :gender, 0

  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56}
  default_value_for :nation, 0

  validates :name, :id_card, presence: true
  scope :sorted, ->{ order(created_at: :asc) }

end
