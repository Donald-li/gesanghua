# == Schema Information
#
# Table name: county_users
#
#  id            :bigint(8)        not null, primary key
#  name          :string                                 # 姓名
#  phone         :string                                 # 联系方式
#  unit_name     :string                                 # 单位名称
#  unit_describe :string                                 # 单位简介
#  user_id       :integer                                # 用户id
#  address       :string                                 # 详细地址
#  province      :string                                 # 省
#  city          :string                                 # 市
#  district      :string                                 # 区/县
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  duty          :string                                 # 职务
#

# 县级用户
require 'custom_validators'
class CountyUser < ApplicationRecord
  belongs_to :user, optional: true

  validates :phone, mobile: true

  scope :sorted, ->{ order(created_at: :desc) }

  # 入驻学校数量
  def enter_school_number
    School.where(district: self.district).count
  end

  # 累计捐助
  def total_school_donate_amount
    School.where(district: self.district).sum(:total_amount)
  end

  # 在执行项目数量
  def executing_project_number
    num = 0
    schools = School.where(district: self.district)
    schools.each do |school|
      num += school.school_executing_project_number
    end
    num
  end

  # 已完成项目数量
  def done_project_number
    num = 0
    schools = School.where(district: self.district)
    schools.each do |school|
      num += school.school_done_project_number
    end
    num
  end

  #异常记录数量
  def exception_record_number
    school_ids = School.where(district: self.district).ids
    apply_ids = ProjectSeasonApply.where(school: school_ids).ids
    ExceptionRecord.where(owner: apply_ids).count
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :phone, :name, :duty)
      json.school_name self.unit_name
      json.kind '县领导'
      json.avatar_url self.user.user_avatar if self.user.present?
      json.user_show_name self.user.show_name if self.user.present?
      json.location [self.province, self.city, self.district]
      json.avatar_image  do
        json.id self.user.try(:avatar).try(:id)
        json.url self.user.try(:user_avatar)
        json.protect_token ''
      end
      json.enter_school_number self.enter_school_number
      json.executing_project_number self.executing_project_number
      json.done_project_number self.done_project_number
      json.exception_record_number self.exception_record_number
      json.total_school_donate_amount self.total_school_donate_amount
    end.attributes!
  end

  def create_county_user
    result = false
    notice = ''
    self.transaction do
      if self.user.present?
        user = self.user
        user.add_role(:county_user)
        user.save!
      end
      unless self.save
        result = false
        notice = self.errors.values.flatten.join(',')
        raise ActiveRecord::Rollback
      end
      result = true
    end
    return result, notice
  end

  def update_county_user(params)
    result = false
    notice = ''
    self.transaction do
      if self.user.present?
        old_user = self.user
        old_user.remove_role(:county_user)
        old_user.save!
      end
      unless self.update(params)
        result = false
        notice = self.errors.values.flatten.join(',')
        raise ActiveRecord::Rollback
      end
      if self.user.present?
        user = self.user
        user.add_role(:county_user)
        user.save!
      end
      result = true
    end
    return result, notice
  end

  def destroy_county_user
    result = false
    notice = ''
    self.transaction do
      if self.user.present?
        user = self.user
        user.remove_role(:county_user)
        user.save!
      end
      self.destroy
      result = true
    end
    return result, notice
  end

end
