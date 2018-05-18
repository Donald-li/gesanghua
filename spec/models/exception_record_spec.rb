# == Schema Information
#
# Table name: exception_records
#
#  id         :integer          not null, primary key
#  title      :string                                 # 标题
#  content    :string                                 # 内容
#  schedule   :string                                 # 进度更新
#  owner_type :string
#  owner_id   :integer
#  user_id    :integer                                # 提交人id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ExceptionRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
