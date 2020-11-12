# == Schema Information
#
# Table name: protocols # 协议
#
#  id         :bigint(8)        not null, primary key
#  kind       :integer                                # 类型
#  title      :string                                 # 标题
#  content    :text                                   # 内容
#  version    :string                                 # 版本
#  project_id :integer                                # 关联项目id
#  state      :integer                                # 状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Protocol < ApplicationRecord
  belongs_to :project, optional: true

  validates :title, presence: true
  validates :content, presence: true

  scope :sorted, ->{order(created_at: :desc)}

  enum kind: {register_protocol: 1, donate_protocol: 2, project_apply_protocol: 3, volunteer_apply_protocol: 4, voucher_protocol: 5, volunteer_introduction: 6, volunteer_rules: 7, volunteer_require: 8}#类型 1注册协议 2捐助协议 3项目申请协议 4志愿者申请协议 5捐赠收据说明 8志愿者保密承诺书

  enum state: {show: 1, hidden: 2}
  default_value_for :state, 1

  def summary_builder
    Jbuilder.new do |json|
      json.(self, :id, :title, :content, :version, :kind, :state, :project_id)
    end.attributes!
  end

end
