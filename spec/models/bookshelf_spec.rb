# == Schema Information
#
# Table name: bookshelves # 书架表
#
#  id               :integer          not null, primary key
#  title            :string                                 # 名称
#  school_id        :integer                                # 学校id
#  class_name       :string                                 # 班级名
#  state            :integer                                # 状态
#  balance          :decimal(14, 2)   default(0.0)          # 剩余金额
#  project_apply_id :integer                                # 项目申请id
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Bookshelf, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
