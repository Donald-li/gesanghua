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
#  state                             :integer                                # 审核状态
#  describe                          :text                                   # 描述
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  present_amount                    :decimal(14, 2)   default(0.0)          # 目前已筹金额
#

FactoryBot.define do
  factory :bookshelf_supplement do
    project_season_apply_bookshelf_id 1
    loss 1
    upply 1
    taget_amount "9.99"
    balance "9.99"
    state 1
  end
end