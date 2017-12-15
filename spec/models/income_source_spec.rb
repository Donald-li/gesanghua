# == Schema Information
#
# Table name: income_sources # 收入来源
#
#  id         :integer          not null, primary key
#  name       :string                                 # 名称
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe IncomeSource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
