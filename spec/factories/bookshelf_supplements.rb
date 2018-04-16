# == Schema Information
#
# Table name: bookshelf_supplements
#
#  id                                :integer          not null, primary key
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
#

FactoryBot.define do
  factory :bookshelf_supplement do
    project_season_apply_bookshelf_id 1
    loss 1
    supply 1
    target_amount "9.99"
    state 1
  end
end
