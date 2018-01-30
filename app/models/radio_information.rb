# == Schema Information
#
# Table name: radio_informations # 广播详细信息表
#
#  id                      :integer          not null, primary key
#  student_number          :integer          default(0)            # 学生总数
#  boarder_number          :integer          default(0)            # 住宿总数
#  dormitory_number        :integer          default(0)            # 宿舍楼总数
#  dorm_number             :integer          default(0)            # 宿舍总数
#  first_grade             :integer          default(0)            # 一年级
#  second_grade            :integer          default(0)            # 二年级
#  third_grade             :integer          default(0)            # 三年级
#  fourth_grade            :integer          default(0)            # 四年级
#  fifth_grade             :integer          default(0)            # 五年级
#  sixth_grade             :integer          default(0)            # 六年级
#  project_season_apply_id :integer                                # 申请id
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class RadioInformation < ApplicationRecord
  belongs_to :project_season_apply

end
