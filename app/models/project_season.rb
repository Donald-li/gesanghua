# == Schema Information
#
# Table name: project_seasons # 项目执行年度表
#
#  id         :integer          not null, primary key
#  project_id :integer                                # 关联项目表id
#  name       :string                                 # 执行年度名称
#  state      :integer                                # 状态 1:未执行 2:执行中
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectSeason < ApplicationRecord
  belongs_to :project
  has_many :project_season_applies, dependent: :destroy

  validates :name, presence: true

  enum state: {enabled: 1, disabled: 2}

  scope :sorted, -> { order(created_at: :desc)}

  def self.pair_project_id
    1 # TODO: 约定为1
  end

end
