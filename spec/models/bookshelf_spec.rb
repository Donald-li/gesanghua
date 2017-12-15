# == Schema Information
#
# Table name: bookshelves # 书架表
#
#  id         :integer          not null, primary key
#  title      :string                                 # 名称
#  school_id  :integer                                # 学校id
#  class_name :string                                 # 班级名
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Bookshelf, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
