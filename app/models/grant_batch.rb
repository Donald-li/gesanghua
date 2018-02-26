# == Schema Information
#
# Table name: grant_batches # 发放批次
#
#  id          :integer          not null, primary key
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

class GrantBatch < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true
  has_many :grants, dependent: :nullify

  enum state: {ungrant: 1, granted: 2} # 状态 1:待发放， 2已发放
  default_value_for :state, 1

  before_create :gen_code

  private
  def gen_code
    time_string = Time.now.strftime("%y%m%d")
    self.batch_no ||= Sequence.get_seq(kind: :grant_batch_no, prefix: time_string, length: 3)
  end

end
