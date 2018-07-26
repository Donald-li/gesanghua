# == Schema Information
#
# Table name: reports # 报告表
#
#  id           :bigint(8)        not null, primary key
#  title        :string                                 # 标题
#  content      :text                                   # 内容
#  type         :string                                 # 单表：audit_report、financial_report、project_report
#  state        :integer                                # 状态
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  project_id   :integer                                # 项目ID
#  published_at :datetime                               # 发布时间
#  position     :integer                                # 位置
#  user_id      :integer                                # 发布人
#

require 'rails_helper'

RSpec.describe BankReport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
