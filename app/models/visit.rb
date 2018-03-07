# == Schema Information
#
# Table name: visits # 家访记录表
#
#  id                      :integer          not null, primary key
#  owner_id                :integer
#  owner_type              :string
#  content                 :text                                   # 内容
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  apply_child_id          :integer                                # 孩子申请ID
#  user_id                 :integer                                # 用户ID
#  investigador            :string                                 # 调查人员
#  escort                  :string                                 # 陪同人员
#  survey_time             :datetime                               # 调查时间
#  family_size             :integer                                # 家庭人数
#  family_basic            :string                                 # 家庭基本情况
#  basic_information       :text                                   # 基本情况
#  income_information      :text                                   # 收入情况
#  expenditure_information :text                                   # 支出情况
#  lodge                   :string                                 # 是否寄宿
#  lodge_cost              :decimal(14, 2)   default(0.0)          # 住宿费用
#  other_subsidize         :text                                   # 其他资助
#  prize_information       :text                                   # 获奖情况
#  study_information       :text                                   # 学习情况
#  tuition_fee             :decimal(14, 2)   default(0.0)          # 学杂费
#  sponsor_fee             :string                                 # 是否赞助生活费
#

# 家访
class Visit < ApplicationRecord

  attr_accessor :image_id

  include HasAsset
  has_one_asset :image, class_name: 'Asset::VisitImage'

  belongs_to :owner, polymorphic: true, optional: true

  has_many :visit_children

  belongs_to :apply_child, class_name: 'ProjectSeasonApplyChild', optional: true
  belongs_to :user

  # validates :content, presence: true

  scope :sorted, ->{ order(created_at: :desc) }

  def simple_builder
    Jbuilder.new do |json|
      json.(self, :id)
      json.author self.user.name
      json.child self.apply_child.name
    end.attributes!
  end

  def detail_builder
    Jbuilder.new do |json|
      json.(self, :id, :investigador, :escort, :family_basic, :family_size, :basic_information, :income_information, :expenditure_information, :lodge, :other_subsidize, :prize_information, :study_information, :tuition_fee, :sponsor_fee)
      json.lodge_cost self.lodge_cost.to_f
      json.survey_time self.survey_time.strftime('%Y-%m-%d')
      json.image do
        json.id self.try(:image).try(:id)
        json.url self.try(:image).try(:file_url)
        json.protect_token self.try(:image).try(:protect_token)
      end
    end.attributes!
  end
end
