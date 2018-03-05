# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id                  :integer          not null, primary key
#  name                :string                                 # 孩子姓名
#  kind                :integer                                # 类型
#  integer             :integer                                # 类型
#  workstation         :string                                 # 工作地点
#  province            :string                                 # 省
#  city                :string                                 # 市
#  district            :string                                 # 区/县
#  gsh_no              :string                                 # 格桑花孩子编号
#  phone               :string                                 # 联系电话
#  qq                  :string                                 # qq号
#  user_id             :integer                                # 关联用户id
#  id_card             :string                                 # 身份证
#  semester_count      :integer          default(0)            # 孩子申请学期总数
#  done_semester_count :integer          default(0)            # 孩子募款成功学期总数
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'custom_validators'
class GshChild < ApplicationRecord

  belongs_to :user, optional: true

  has_many :project_season_apply_children, dependent: :destroy

  validates :name, presence: true
  validates :province, :city, :district, presence: true
  validates :phone, mobile: true
  validates :qq, qq: true
  validates :id_card, shenfenzheng_no: true

  enum kind: {student: 1, worker: 2}
  default_value_for :kind, 1

  scope :sorted, ->{ order(created_at: :desc) }

  before_create :gen_gsh_no

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :gsh_no)
      json.child_id self.apply_child.id
      json.grants self.semesters.where(user_id: self.user_id).pluck(:title).join('/').gsub(/\s/, '').strip
      json.donate_state self.semesters.pending.size > 0
      json.num self.apply_child.feedbacks.continue.count
      json.avatar self.apply_child.avatar.present? ? self.apply_child.avatar_url(:tiny).to_s : ''
    end.attributes!
  end

  def child_info_builder
    Jbuilder.new do |json|
      json.(self, :id, :id_card, :workstation)
      json.name self.name
      json.kind self.kind
      json.kind_name self.enum_name(:kind)
      json.gsh_no self.gsh_no
      json.location [self.province, self.city, self.district]
      # json.avatar self.avatar.present? ? self.avatar_url(:tiny).to_s : ''
    end.attributes!
  end

  private
  def gen_gsh_no
    self.gsh_no ||= Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 10)
  end

end
