# == Schema Information
#
# Table name: child_periods # 孩子捐助学期表
#
#  id                :integer          not null, primary key
#  grant_id          :integer                                # 发放记录ID
#  project_season_id :integer                                # 项目年度ID
#  gsh_child_id      :integer                                # 格桑花孩子ID
#  donate_record_id  :integer                                # 捐助记录ID
#  user_id           :integer                                # 捐赠人ID
#  name              :string                                 # 名称
#  description       :text                                   # 描述
#  state             :integer                                # 状态
#  amount            :decimal(14, 2)   default(0.0)          # 资助金额
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe ChildPeriod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end