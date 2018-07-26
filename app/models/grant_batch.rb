# == Schema Information
#
# Table name: grant_batches # 发放批次
#
#  id          :bigint(8)        not null, primary key
#  project_id  :integer                                # 所属项目
#  batch_no    :string                                 # 批次号
#  name        :string                                 # 名称
#  description :text                                   # 描述
#  state       :integer                                # 状态
#  user_id     :integer                                # 发放负责人
#  grant_at    :datetime                               # 发放时间
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# 一对一发放批次
class GrantBatch < ApplicationRecord
  has_paper_trail only: [:project_id, :batch_no, :name, :description, :state, :user_id, :grant_at]

  belongs_to :project
  belongs_to :user, optional: true
  has_many :grants, class_name: 'GshChildGrant', foreign_key: :grant_batch_id, dependent: :nullify

  enum state: {waiting: 1, granted: 2} # 状态 1:待发放， 2已发放
  default_value_for :state, 1

  default_value_for(:project_id){ Project.pair_project.try(:id) }

  scope :sorted, ->{ order(id: :desc) }

  before_create :gen_code

  # 总数
  def total_count
    self.grants.count
  end

  # 已发放数
  def granted_count
    self.grants.granted.count
  end

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :batch_no, :project_id, :name, :state, :user_id, :description)
      json.total_count self.total_count
      json.created_at self.created_at.strftime("%Y-%m-%d %H:%M")
      json.granted_count self.granted_count
    end.attributes!
  end

  private
  def gen_code
    time_string = Time.now.strftime("%y%m%d")
    self.batch_no ||= Sequence.get_seq(kind: :grant_batch_no, prefix: time_string, length: 3)
  end

end
