# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id                  :integer          not null, primary key
#  school_id           :integer                                # 关联学校id
#  name                :string                                 # 孩子姓名
#  province            :string                                 # 省
#  city                :string                                 # 市
#  district            :string                                 # 区/县
#  gsh_no              :string                                 # 格桑花孩子编号
#  phone               :string                                 # 联系电话
#  qq                  :string                                 # qq号
#  user_id             :integer                                # 关联用户id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  idcard              :string                                 # 身份证
#  semester_count      :integer          default(0)            # 孩子申请学期总数
#  done_semester_count :integer          default(0)            # 孩子募款成功学期总数
#

require 'custom_validators'
class GshChild < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :school, optional: true

  # TODO: 孩子表和申请孩子是一对多关系？
  has_many :project_season_apply_children, dependent: :destroy

  has_one :apply_child, class_name: 'ProjectSeasonApplyChild'

  has_many :gsh_child_grants, dependent: :destroy

  has_many :semesters, class_name: 'GshChildGrant', dependent: :destroy


  validates :name, presence: true
  validates :province, :city, :district, presence: true
  validates :phone, mobile: true
  validates :qq, qq: true
  validates :idcard, shenfenzheng_no: true

  scope :sorted, ->{ order(created_at: :desc) }

  before_create :gen_gsh_no

  # 筹款进度
  def gift_progress
    "#{self.done_semester_count}/#{self.semester_count}"
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :gsh_no)
      json.child_id self.apply_child.id
      json.grants self.semesters.where(user_id: self.user_id).pluck(:title).join('/').gsub(/\s/, '').strip
      json.donate_state self.semesters.pending.size > 0
      json.num self.apply_child.continuals.count
      json.avatar self.apply_child.avatar.present? ? self.apply_child.avatar_url(:tiny).to_s : ''
    end.attributes!
  end

  private
  def gen_gsh_no
    self.gsh_no ||= Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 10)
  end

end
