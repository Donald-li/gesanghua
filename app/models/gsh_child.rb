# == Schema Information
#
# Table name: gsh_children # 格桑花孩子表
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 关联学校id
#  name       :string                                 # 孩子姓名
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  gsh_no     :string                                 # 格桑花孩子编号
#  phone      :string                                 # 联系电话
#  qq         :string                                 # qq号
#  user_id    :integer                                # 关联用户id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  idcard     :string                                 # 身份证
#
require 'custom_validators'
class GshChild < ApplicationRecord

  default_value_for(:gsh_no){ Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 10, save: false)  }

  belongs_to :user, optional: true
  belongs_to :school, optional: true

  has_many :project_season_apply_children

  validates :name, presence: true
  validates :province, :city, :district, presence: true
  validates :phone, mobile: true
  validates :qq, qq: true
  validates :idcard, shenfenzheng_no: true

  scope :sorted, ->{ order(created_at: :desc) }

  before_create :gen_gsh_no

  private
  def gen_gsh_no
    self.gsh_no ||= Sequence.get_seq(kind: :gsh_no, prefix: 'GSH', length: 10)
  end
end
