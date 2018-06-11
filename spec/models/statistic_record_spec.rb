# == Schema Information
#
# Table name: statistic_records
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0)            # 今日更新数量
#  kind        :integer                                # 类型
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  record_time :datetime                               # 统计时间
#  owner_type  :string
#  owner_id    :integer
#

require 'rails_helper'

RSpec.describe StatisticRecord, type: :model do
  
end
