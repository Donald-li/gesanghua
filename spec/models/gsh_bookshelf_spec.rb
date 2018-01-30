# == Schema Information
#
# Table name: gsh_bookshelves
#
#  id                      :integer          not null, primary key
#  school_id               :integer                                # 关联学校id
#  classname               :string                                 # 班级名
#  title                   :string                                 # 冠名
#  province                :string                                 # 省
#  city                    :string                                 # 市
#  district                :string                                 # 区/县
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  bookshelf_no            :string                                 # 图书角编号
#  univalence              :decimal(14, 2)   default(0.0)          # 单个金额
#  balance                 :decimal(14, 2)   default(0.0)          # 单个筹款剩余金额
#  extra_amount            :decimal(14, 2)   default(0.0)          # 补书金额
#  audit_state             :integer                                # 审核状态
#  show_state              :integer                                # 展示状态
#  state                   :integer                                # 执行状态
#  project_season_apply_id :integer                                # 项目申请ID
#  project_season_id       :integer                                # 批次申请ID
#

require 'rails_helper'

RSpec.describe GshBookshelf, type: :model do
  
end
