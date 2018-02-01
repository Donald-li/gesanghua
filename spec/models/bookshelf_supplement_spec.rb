# == Schema Information
#
# Table name: bookshelf_supplements
#
#  id                                :integer          not null, primary key
#  project_season_apply_bookshelf_id :integer                                # 书架ID
#  project_season_apply_id           :integer                                # 申请ID
#  loss                              :integer                                # 损耗数量
#  upply                             :integer                                # 补充数量
#  taget_amount                      :decimal(14, 2)   default(0.0)          # 目标金额
#  balance                           :decimal(14, 2)   default(0.0)          # 剩余金额
#  state                             :integer                                # 审核状态
#  describe                          :text                                   # 描述
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

require 'rails_helper'

RSpec.describe BookshelfSupplement, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
