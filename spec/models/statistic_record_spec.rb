# == Schema Information
#
# Table name: statistic_records
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0)            # 今日更新数量
#  kind       :integer                                # 类型
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe StatisticRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
