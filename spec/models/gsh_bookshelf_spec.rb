# == Schema Information
#
# Table name: gsh_bookshelves
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 关联学校id
#  classname  :string                                 # 班级名
#  title      :string                                 # 冠名
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe GshBookshelf, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
