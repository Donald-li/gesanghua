# == Schema Information
#
# Table name: beneficial_children
#
#  id                                :bigint(8)        not null, primary key
#  id_no                             :string                                 # 身份证号
#  name                              :string                                 # 姓名
#  gender                            :integer                                # 性别
#  nation                            :integer                                # 民族
#  project_season_apply_id           :integer                                # 项目申请ID
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  project_season_apply_bookshelf_id :integer                                # 书架id
#

require 'rails_helper'

RSpec.describe BeneficialChild, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
