# == Schema Information
#
# Table name: bookshelf_supplements
#
#  id                                :bigint(8)        not null, primary key
#  project_season_apply_bookshelf_id :integer                                # 书架ID
#  project_season_apply_id           :integer                                # 申请ID
#  loss                              :integer                                # 损耗数量
#  state                             :integer                                # 审核状态
#  describe                          :text                                   # 描述
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  present_amount                    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  supply                            :integer                                # 补充数量
#  target_amount                     :decimal(14, 2)   default(0.0)          # 目标金额
#  audit_state                       :integer                                # 审核状态
#  show_state                        :integer                                # 显示状态
#  project_id                        :integer                                # 项目id
#  management_fee_state              :integer                                # 计提管理费状态
#

require 'rails_helper'

RSpec.describe BookshelfSupplement, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
