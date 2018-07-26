# == Schema Information
#
# Table name: family_members # 家庭成员表
#
#  id               :bigint(8)        not null, primary key
#  visit_id         :integer                                # 家访表ID
#  name             :string                                 # 成员姓名
#  age              :integer                                # 年龄
#  relationship     :string                                 # 关系
#  profession       :string                                 # 职业
#  health_condition :text                                   # 健康状况
#  job_condition    :text                                   # 工作情况
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class FamilyMember < ApplicationRecord

  belongs_to :visit, optional: true

  scope :sorted, ->{ order(created_at: :desc) }

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :age, :relationship, :profession, :health_condition, :job_condition)
    end.attributes!
  end

end
