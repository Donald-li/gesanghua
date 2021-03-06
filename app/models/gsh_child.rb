# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id                  :bigint(8)        not null, primary key
#  name                :string                                 # 孩子姓名
#  kind                :integer                                # 类型
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
  has_paper_trail only: [:name, :kind, :workstation, :province, :city, :district, :gsh_no, :phone, :qq, :user_id, :id_card, :semester_count, :done_semester_count]

  belongs_to :user, optional: true

  has_many :project_season_apply_children, dependent: :nullify
  has_many :project_season_apply_camp_members, dependent: :nullify
  has_many :continual_feedbacks, as: :owner, dependent: :nullify

  validates :name, presence: true
  # validates :province, :city, :district, presence: true
  validates :phone, mobile: true
  validates :qq, qq: true
  validates :id_card, shenfenzheng_no: true

  include HasAsset
  has_one_asset :avatar, class_name: 'Asset::GshChildAvatar'

  enum kind: {student: 1, worker: 2}
  default_value_for :kind, 1

  scope :sorted, ->{ order(created_at: :desc) }

  scope :visible, ->{ where('semester_count > done_semester_count') } # 前端列表可见

  before_create :gen_gsh_no
  before_save :formatted_name


  #性别
  def distinguish_gender
    gender = nil
    return gender if self.id_card.blank?
    pid_gender = ChinesePid.new("#{self.id_card}").gender
    gender = '男' if pid_gender == 1
    gender = '女' if pid_gender == 0
    return gender
  end


  def summary_builder
    apply_child = self.project_season_apply_children.first
    Jbuilder.new do |json|
      json.(self, :id, :name, :gsh_no)
      json.child_id apply_child.id
      json.grants self.semesters.where(user_id: self.user_id).pluck(:title).join('/').gsub(/\s/, '').strip
      json.donate_state self.semesters.pending.size > 0
      json.num apply_child.feedbacks.continue.count
      json.avatar apply_child.child_avatar
    end.attributes!
  end

  def simple_address
    ChinaCity.get(self.province).to_s + ChinaCity.get(self.city).to_s + ChinaCity.get(self.district).to_s # + self.address.to_s
  end

  def child_info_builder
    Jbuilder.new do |json|
      json.(self, :id, :id_card, :workstation)
      json.name self.name
      json.kind self.kind
      json.kind_name self.enum_name(:kind)
      json.gsh_no self.gsh_no
      json.location [self.province, self.city, self.district]
      json.avatar self.try(:avatar_url, :tiny).to_s
    end.attributes!
  end

  def pair_feedback_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :id_card, :gsh_no)
      # json.id_card self.secure_id_card
    end.attributes!
  end

  def check_gsh_child_builder
    Jbuilder.new do |json|
      json.(self, :id, :name, :phone)
      json.kind '格桑花孩子'
    end.attributes!
  end

  private
  def gen_gsh_no
    self.gsh_no = self.gsh_no.presence || Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 9)
  end

  def formatted_name
    self.name = self.name.to_s.strip
  end

end
