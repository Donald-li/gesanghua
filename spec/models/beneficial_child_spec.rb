# == Schema Information
#
# Table name: beneficial_children
#
#  id                      :integer          not null, primary key
#  id_no                   :string                                 # 身份证号
#  name                    :string                                 # 姓名
#  gender                  :integer                                # 性别
#  nation                  :integer                                # 民族
#  gsh_bookshelf_id        :integer                                # 图书角ID
#  project_season_apply_id :integer                                # 项目申请ID
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe BeneficialChild, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
