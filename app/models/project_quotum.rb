# == Schema Information
#
# Table name: project_quota # 项目配额
#
#  id         :integer          not null, primary key
#  school_id  :integer                                # 学校ID
#  project_id :integer                                # 项目ID
#  amount     :decimal(14, 2)   default(0.0)          # 金额
#  province   :string                                 # 省
#  city       :string                                 # 市
#  district   :string                                 # 区/县
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectQuotum < ApplicationRecord
  belongs_to :school
  belongs_to :project

  validates :province, :city, :district, presence: true

end
